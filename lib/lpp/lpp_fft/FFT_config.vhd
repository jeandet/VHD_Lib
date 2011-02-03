------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA 
------------------------------------------------------------------------------
--                        Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

Package FFT_config is

--===========================================================|
--======================= Valeurs ===========================|
--===================== Sinus 500 hz ========================|
--========================== et =============================|
--==================== Somme de Sinus =======================|
--===========================================================|

type Tbl is array(natural range <>) of std_logic_vector(15 downto 0);

constant Tablo_In : Tbl (0 to 99):= (X"0000",X"080A",X"100B",X"17FC",X"1FD5",X"278E",X"2F1F",X"3680",X"3DAA",X"4496",X"4B3D",X"5197",X"579F",X"5D4F",X"62A0",X"678E",X"6C13",X"702B",X"73D1",X"7703",X"79BC",X"7BFB",X"7DBC",X"7EFE",X"7FBF",X"7FFF",X"7FBF",X"7EFE",X"7DBC",X"7BFB",X"79BC",X"7703",X"73D1",X"702B",X"6C13",X"678E",X"62A0",X"5D4F",X"579F",X"5197",X"4B3D",X"4496",X"3DAA",X"3680",X"2F1F",X"278E",X"1FD5",X"17FC",X"100B",X"080A",X"0000",X"F7F6",X"EFF5",X"E804",X"E02B",X"D872",X"D0E1",X"C980",X"C256",X"BB6A",X"B4C3",X"AE69",X"A861",X"A2B1",X"9D60",X"9872",X"93ED",X"8FD5",X"8C2F",X"88FD",X"8644",X"8405",X"8244",X"8102",X"8041",X"8000",X"8041",X"8102",X"8244",X"8405",X"8644",X"88FD",X"8C2F",X"8FD5",X"93ED",X"9872",X"9D60",X"A2B1",X"A861",X"AE69",X"B4C3",X"BB6A",X"C256",X"C980",X"D0E1",X"D872",X"E02B",X"E804",X"EFF5",X"F7F6");

constant Tablo_Input : Tbl (0 to 249):= (X"0000",X"1AA8",X"3151",X"409E",X"4661",X"41EE",X"343D",X"1FBE",X"07F6",X"F0F1",X"DE9A",X"D420",X"D36B",X"DCD9",X"EF26",X"07A5",X"22AA",X"3C22",X"5039",X"5BF5",X"5DB3",X"5564",X"4495",X"2E2C",X"15F4",X"0000",X"F007",X"E8C8",X"EBA1",X"F84D",X"0CFB",X"268C",X"411C",X"589D",X"697A",X"7130",X"6EAD",X"6280",X"4EC4",X"36C4",X"1E7A",X"09E9",X"FC7D",X"F879",X"FEA1",X"0E19",X"2485",X"3E6C",X"57C6",X"6CA0",X"79BC",X"7D19",X"7640",X"665B",X"5004",X"36D8",X"1EEA",X"0C17",X"0168",X"009B",X"09D6",X"1BA6",X"3337",X"4CC7",X"6442",X"75E9",X"7EE7",X"7DC7",X"72B1",X"5F61",X"46E3",X"2D14",X"1603",X"0551",X"FD98",X"0000",X"0C14",X"1FD2",X"37FD",X"50A2",X"65B8",X"73C8",X"7876",X"72E6",X"63DA",X"4D99",X"338D",X"19BA",X"0419",X"F5F9",X"F170",X"F711",X"05CA",X"1B17",X"3365",X"4AA5",X"5CF2",X"6732",X"6790",X"5DCA",X"4B3D",X"32A9",X"17C5",X"FEA4",X"EB13",X"DFF7",X"DEDE",X"E7BB",X"F8E9",X"0F6F",X"277A",X"3CF7",X"4C3B",X"529A",X"4ED0",X"413B",X"2BC4",X"119A",X"F6A9",X"DEFD",X"CE1D",X"C678",X"C906",X"D51E",X"E88F",X"0000",X"1771",X"2AE2",X"36FA",X"3988",X"31E3",X"2103",X"0957",X"EE66",X"D43C",X"BEC5",X"B130",X"AD66",X"B3C5",X"C309",X"D886",X"F091",X"0717",X"1845",X"2122",X"2009",X"14ED",X"015C",X"E83B",X"CD57",X"B4C3",X"A236",X"9870",X"98CE",X"A30E",X"B55B",X"CC9B",X"E4E9",X"FA36",X"08EF",X"0E90",X"0A07",X"FBE7",X"E646",X"CC73",X"B267",X"9C26",X"8D1A",X"878A",X"8C38",X"9A48",X"AF5E",X"C803",X"E02E",X"F3EC",X"0000",X"0268",X"FAAF",X"E9FD",X"D2EC",X"B91D",X"A09F",X"8D4F",X"8239",X"8119",X"8A17",X"9BBE",X"B339",X"CCC9",X"E45A",X"F62A",X"FF65",X"FE98",X"F3E9",X"E116",X"C928",X"AFFC",X"99A5",X"89C0",X"82E7",X"8644",X"9360",X"A83A",X"C194",X"DB7B",X"F1E7",X"015F",X"0787",X"0383",X"F617",X"E186",X"C93C",X"B13C",X"9D80",X"9153",X"8ED0",X"9686",X"A763",X"BEE4",X"D974",X"F305",X"07B3",X"145F",X"1738",X"0FF9",X"0000",X"EA0C",X"D1D4",X"BB6B",X"AA9C",X"A24D",X"A40B",X"AFC7",X"C3DE",X"DD56",X"F85B",X"10DA",X"2327",X"2C95",X"2BE0",X"2166",X"0F0F",X"F80A",X"E042",X"CBC3",X"BE12",X"B99F",X"BF62",X"CEAF",X"E558");

end;