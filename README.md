# ABOUT


LPP's VHD_Lib is a kind of addon to gaisler's grlib with most [LPP](http://www.lpp.fr/?lang=en) VHDL IPs. For setup read instalation section.


# REQUIREMENTS


To use this library you need the grlib and linux shell or mingw for windows users.
[Jupyter](http://jupyter.org/) and [GHDL](http://ghdl.free.fr/) migh also be useful.


# PERSONALIZATION


You can add your IPs to the library.


# INSTALLATION


To set up the VHD_Lib follow this steps:

1. download and extract the [grlib](http://www.gaisler.com/index.php/downloads/leongrlib)

2. create a VARIABLE called GRLIB with value the path to the extracted grlib folder.

3. untar the VHD_Lib and run the following command from VHD_Lib folder:

```bash
make link
```

4. now you can use VHD_Lib's and grlib's Makefiles, designs and IPs.

Please note that if you try "make help" you will see all targets and if the GRLIB variable is correct.


# LICENSE

All the programs used by the VHD_Lib are protected by their respective
license. They all are free software and most of them are covered by the
GNU General Public License.

# Feedback

Please send feedbacks to **Alexis Jeandet**  alexis.jeandet@member.fsf.org

