import curl
from elftools.elf import elffile
import io
import lfrcompliance.tcpackets.telecommands as tc
import lfrcompliance.rmap.rmap_request as rmap
import shutil
import os

DSUBASEADDRESS = 0x90000000
APBIRQCTRLRBASEADD = 0x80000200
APBTIMERBASEADD = 0x80000300
ramSize=1024*1024*4

# get flight software elf rev 3.1.0.2
req=curl.Curl("https://hephaistos.lpp.polytechnique.fr/data/LFR/SW/LFR-FSW/3.1.0.2/fsw")
req.set_timeout(100)
fsw=elffile.ELFFile(io.BytesIO(req.get()))
fsw_text=fsw.get_section_by_name(".text")
fsw_text_addr=fsw_text.header['sh_addr']
fsw_data=fsw.get_section_by_name(".data")
fsw_data_addr=fsw_data.header['sh_addr']

def to_spw_packet(telecommand):
    return [tc.TARGET_LOGICAL_ADDRESS,
            tc.PROTOCOLE_IDENTIFIER_CCSDS,
            tc.RESERVED_DEFAULT, tc.USER_APPLICATION]+telecommand.ccsdsPacket

def append_packets(file,packets):
    with open(file,"a+") as spw:
        for packet in packets:
            spw.write("{} {}\n".format(0,len(packet)))
            [ spw.write(str(char)+"\n") for char in packet ]

def chunks(l, n):
    """Yield successive n-sized chunks from l."""
    for i in range(0, len(l), n):
        yield l[i:i + n]

with open("./spw_input.txt","w") as spw:
    pass

rmap_packets_config=[
    #Force a debug break
    rmap.rmap_write_reg(DSUBASEADDRESS,0x0000002f),
    rmap.rmap_write_reg(DSUBASEADDRESS+0x20,0x0000ffff),
    #//Clear time tag counter
    rmap.rmap_write_reg(DSUBASEADDRESS+0x8,0),
    #//    //Clear ASR registers
    rmap.rmap_memset(DSUBASEADDRESS+0x400040,0,3),
    rmap.rmap_write_reg(DSUBASEADDRESS+0x400024,0x2),
    rmap.rmap_memset(DSUBASEADDRESS+0x400060,0,8),
    rmap.rmap_write_reg(DSUBASEADDRESS+0x48,0x0),
    rmap.rmap_write_reg(DSUBASEADDRESS+0x000004C,0x0),
    rmap.rmap_write_reg(DSUBASEADDRESS+0x400040,0x0),
    rmap.rmap_memset(DSUBASEADDRESS+0x400060,0,4),
    rmap.rmap_write_reg(DSUBASEADDRESS+0x24,0x0000FFFF),
    rmap.rmap_memset(DSUBASEADDRESS+0x300000,0,1567),
    rmap.rmap_write_regs(DSUBASEADDRESS+0x400000,[0,0xF30000E0,0x00000002,0x40000000,0x40000000,0x40000004,0x1000000]),
    rmap.rmap_write_regs(DSUBASEADDRESS+0x300020,[0,0,0,0,0,0,0x40000000+ramSize-16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
    rmap.rmap_write_reg(DSUBASEADDRESS,0x000002EF),
    rmap.rmap_write_reg(APBIRQCTRLRBASEADD+0x040,0),
    rmap.rmap_write_reg(APBIRQCTRLRBASEADD+0x080,0xFFFE0000),
    rmap.rmap_memset(APBIRQCTRLRBASEADD,0,2),
    rmap.rmap_write_reg(APBTIMERBASEADD+0x014,0xffffffff),
    rmap.rmap_write_reg(APBTIMERBASEADD+0x04,0x00000018),
    rmap.rmap_write_reg(APBTIMERBASEADD+0x018,0x00000007),
]
rmap_packets_start=[
    #//start
    rmap.rmap_write_reg(DSUBASEADDRESS+0x020,0x0)]

#    //load sw
#   //load .text
rmap_packets_sw=[]
fsw_text_chunks= list(chunks(fsw_text.data(), 8*1024))
for index in range(len(fsw_text_chunks)):
    rmap_packets_sw.append(
        rmap.rmap_request(fsw_text_addr+(index*8*1024),
                     write=1,
                     data=fsw_text_chunks[index]).packet)

fsw_data_chunks= list(chunks(fsw_text.data(), 8*1024))
for index in range(len(fsw_data_chunks)):
    rmap_packets_sw.append(
        rmap.rmap_request(fsw_data_addr+(index*8*1024),
                     write=1,
                     data=fsw_data_chunks[index]).packet)

append_packets("./spw_input.txt",rmap_packets_config+rmap_packets_sw+rmap_packets_start)

tc_enter_SBM1= tc.TCLFREnterMode(tc.DEFAULT_SEQUENCE_COUNT,tc.RPW_INTERNAL,tc.SBM1,0)
tc_LoadNormalPar=tc.TCLFRLoadNormalPar(tc.DEFAULT_SEQUENCE_COUNT,tc.RPW_INTERNAL)
tc_LoadNormalPar.setSY_LFR_N_ASM_P(4)
tc_LoadNormalPar.setSY_LFR_N_CWF_LONG_F3(1)
tc_LoadNormalPar.setSY_LFR_N_SWF_P(22)

tc_CommonPar=tc.TCLFRLoadCommonPar(tc.DEFAULT_SEQUENCE_COUNT,tc.RPW_INTERNAL)
tc_CommonPar.setSY_LFR_BW(1)
tc_CommonPar.setSY_LFR_R0(0)
tc_CommonPar.setSY_LFR_R1(1)
tc_CommonPar.setSY_LFR_R2(1)
tc_CommonPar.setSY_LFR_SP0(1)
tc_CommonPar.setSY_LFR_SP1(0)

append_packets("./spw_input.txt",[
    to_spw_packet(tc_CommonPar),
    to_spw_packet(tc_LoadNormalPar),
    to_spw_packet(tc_enter_SBM1)
])



