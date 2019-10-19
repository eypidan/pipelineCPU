<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="kintex7" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="clk" />
        <signal name="reset" />
        <signal name="Data_in(31:0)" />
        <signal name="inst_in(31:0)" />
        <signal name="inst_in(31:26)" />
        <signal name="inst_in(5:0)" />
        <signal name="INT" />
        <signal name="mem_w" />
        <signal name="CPU_MIO" />
        <signal name="Addr_out(31:0)" />
        <signal name="Data_out(31:0)" />
        <signal name="PC_out(31:0)" />
        <signal name="inst_in(25:0)" />
        <signal name="MIO_ready" />
        <signal name="zero" />
        <signal name="XLXN_17" />
        <signal name="XLXN_18" />
        <signal name="XLXN_19" />
        <signal name="XLXN_20" />
        <signal name="XLXN_24" />
        <signal name="XLXN_25(5:0)" />
        <signal name="XLXN_26(5:0)" />
        <signal name="XLXN_27" />
        <signal name="XLXN_29(25:0)" />
        <signal name="XLXN_30" />
        <signal name="XLXN_32" />
        <signal name="XLXN_33" />
        <signal name="XLXN_34" />
        <signal name="XLXN_35" />
        <signal name="XLXN_36(1:0)" />
        <signal name="XLXN_37(2:0)" />
        <signal name="XLXN_38(1:0)" />
        <signal name="XLXN_39" />
        <signal name="XLXN_40" />
        <signal name="XLXN_41(31:0)" />
        <port polarity="Input" name="clk" />
        <port polarity="Input" name="reset" />
        <port polarity="Input" name="Data_in(31:0)" />
        <port polarity="Input" name="inst_in(31:0)" />
        <port polarity="Input" name="INT" />
        <port polarity="Output" name="mem_w" />
        <port polarity="Output" name="CPU_MIO" />
        <port polarity="Output" name="Addr_out(31:0)" />
        <port polarity="Output" name="Data_out(31:0)" />
        <port polarity="Output" name="PC_out(31:0)" />
        <port polarity="Input" name="MIO_ready" />
        <blockdef name="SCPU_ctrl">
            <timestamp>2019-10-7T11:19:21</timestamp>
            <rect width="336" x="64" y="-640" height="640" />
            <line x2="0" y1="-608" y2="-608" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <rect width="64" x="0" y="-236" height="24" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="464" y1="-608" y2="-608" x1="400" />
            <line x2="464" y1="-544" y2="-544" x1="400" />
            <line x2="464" y1="-480" y2="-480" x1="400" />
            <line x2="464" y1="-416" y2="-416" x1="400" />
            <line x2="464" y1="-352" y2="-352" x1="400" />
            <line x2="464" y1="-288" y2="-288" x1="400" />
            <line x2="464" y1="-224" y2="-224" x1="400" />
            <rect width="64" x="400" y="-172" height="24" />
            <line x2="464" y1="-160" y2="-160" x1="400" />
            <rect width="64" x="400" y="-108" height="24" />
            <line x2="464" y1="-96" y2="-96" x1="400" />
            <rect width="64" x="400" y="-44" height="24" />
            <line x2="464" y1="-32" y2="-32" x1="400" />
        </blockdef>
        <blockdef name="Data_path">
            <timestamp>2019-10-7T11:18:58</timestamp>
            <rect width="352" x="64" y="-768" height="768" />
            <rect width="64" x="0" y="-748" height="24" />
            <line x2="0" y1="-736" y2="-736" x1="64" />
            <line x2="0" y1="-672" y2="-672" x1="64" />
            <rect width="64" x="0" y="-620" height="24" />
            <line x2="0" y1="-608" y2="-608" x1="64" />
            <rect width="64" x="0" y="-556" height="24" />
            <line x2="0" y1="-544" y2="-544" x1="64" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <rect width="64" x="0" y="-364" height="24" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <rect width="64" x="0" y="-300" height="24" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="416" y="-748" height="24" />
            <line x2="480" y1="-736" y2="-736" x1="416" />
            <rect width="64" x="416" y="-572" height="24" />
            <line x2="480" y1="-560" y2="-560" x1="416" />
            <rect width="64" x="416" y="-396" height="24" />
            <line x2="480" y1="-384" y2="-384" x1="416" />
            <line x2="480" y1="-208" y2="-208" x1="416" />
            <line x2="480" y1="-32" y2="-32" x1="416" />
        </blockdef>
        <block symbolname="SCPU_ctrl" name="XLXI_1">
            <blockpin signalname="MIO_ready" name="MIO_ready" />
            <blockpin signalname="zero" name="zero" />
            <blockpin signalname="inst_in(31:26)" name="OPcode(5:0)" />
            <blockpin signalname="inst_in(5:0)" name="Fun(5:0)" />
            <blockpin signalname="XLXN_30" name="RegDst" />
            <blockpin signalname="XLXN_32" name="ALUSrc_B" />
            <blockpin signalname="XLXN_33" name="RegWrite" />
            <blockpin signalname="mem_w" name="mem_w" />
            <blockpin signalname="XLXN_34" name="Jal" />
            <blockpin signalname="CPU_MIO" name="CPU_MIO" />
            <blockpin signalname="XLXN_35" name="ALUSrc_A" />
            <blockpin signalname="XLXN_36(1:0)" name="DatatoReg(1:0)" />
            <blockpin signalname="XLXN_37(2:0)" name="ALU_Control(2:0)" />
            <blockpin signalname="XLXN_38(1:0)" name="Branch(1:0)" />
        </block>
        <block symbolname="Data_path" name="XLXI_2">
            <blockpin signalname="inst_in(25:0)" name="inst_field(25:0)" />
            <blockpin signalname="XLXN_30" name="RegDst" />
            <blockpin signalname="XLXN_36(1:0)" name="DatatoReg(1:0)" />
            <blockpin signalname="Data_in(31:0)" name="Data_in(31:0)" />
            <blockpin signalname="reset" name="rst" />
            <blockpin signalname="clk" name="clk" />
            <blockpin signalname="XLXN_38(1:0)" name="Branch(1:0)" />
            <blockpin signalname="XLXN_37(2:0)" name="ALU_Control(2:0)" />
            <blockpin signalname="XLXN_32" name="ALUSrc_B" />
            <blockpin signalname="XLXN_33" name="RegWrite" />
            <blockpin signalname="XLXN_34" name="Jal" />
            <blockpin signalname="XLXN_35" name="ALUSrc_A" />
            <blockpin signalname="PC_out(31:0)" name="PC_out(31:0)" />
            <blockpin signalname="Addr_out(31:0)" name="ALU_out(31:0)" />
            <blockpin signalname="Data_out(31:0)" name="Data_out(31:0)" />
            <blockpin signalname="zero" name="zero" />
            <blockpin name="overflow" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <branch name="clk">
            <wire x2="2096" y1="1072" y2="1072" x1="928" />
            <wire x2="2128" y1="1024" y2="1024" x1="2096" />
            <wire x2="2096" y1="1024" y2="1072" x1="2096" />
        </branch>
        <branch name="reset">
            <wire x2="2096" y1="1008" y2="1008" x1="960" />
            <wire x2="2096" y1="960" y2="1008" x1="2096" />
            <wire x2="2128" y1="960" y2="960" x1="2096" />
        </branch>
        <branch name="Data_in(31:0)">
            <wire x2="2096" y1="944" y2="944" x1="928" />
            <wire x2="2128" y1="896" y2="896" x1="2096" />
            <wire x2="2096" y1="896" y2="944" x1="2096" />
        </branch>
        <branch name="inst_in(31:0)">
            <wire x2="1152" y1="688" y2="688" x1="928" />
            <wire x2="1440" y1="688" y2="688" x1="1152" />
            <wire x2="1440" y1="688" y2="704" x1="1440" />
            <wire x2="1152" y1="688" y2="1120" x1="1152" />
            <wire x2="1152" y1="1120" y2="1200" x1="1152" />
            <wire x2="1152" y1="1200" y2="1248" x1="1152" />
        </branch>
        <bustap x2="1248" y1="1120" y2="1120" x1="1152" />
        <branch name="inst_in(31:26)">
            <wire x2="1280" y1="1120" y2="1120" x1="1248" />
            <wire x2="1280" y1="1120" y2="1536" x1="1280" />
            <wire x2="1312" y1="1536" y2="1536" x1="1280" />
        </branch>
        <bustap x2="1248" y1="1200" y2="1200" x1="1152" />
        <branch name="inst_in(5:0)">
            <wire x2="1248" y1="1200" y2="1728" x1="1248" />
            <wire x2="1312" y1="1728" y2="1728" x1="1248" />
        </branch>
        <iomarker fontsize="28" x="992" y="1488" name="MIO_ready" orien="R180" />
        <branch name="INT">
            <wire x2="1120" y1="1616" y2="1616" x1="832" />
        </branch>
        <iomarker fontsize="28" x="832" y="1616" name="INT" orien="R180" />
        <branch name="CPU_MIO">
            <wire x2="1792" y1="1472" y2="1472" x1="1776" />
            <wire x2="1792" y1="1472" y2="1488" x1="1792" />
            <wire x2="1840" y1="1488" y2="1488" x1="1792" />
        </branch>
        <branch name="Data_out(31:0)">
            <wire x2="2688" y1="1056" y2="1056" x1="2608" />
            <wire x2="2688" y1="1056" y2="1072" x1="2688" />
            <wire x2="2768" y1="1072" y2="1072" x1="2688" />
        </branch>
        <branch name="Addr_out(31:0)">
            <wire x2="2704" y1="880" y2="880" x1="2608" />
            <wire x2="2704" y1="880" y2="912" x1="2704" />
            <wire x2="2752" y1="912" y2="912" x1="2704" />
        </branch>
        <iomarker fontsize="28" x="2768" y="1072" name="Data_out(31:0)" orien="R0" />
        <iomarker fontsize="28" x="2752" y="912" name="Addr_out(31:0)" orien="R0" />
        <iomarker fontsize="28" x="928" y="688" name="inst_in(31:0)" orien="R180" />
        <bustap x2="1536" y1="704" y2="704" x1="1440" />
        <branch name="inst_in(25:0)">
            <wire x2="2128" y1="704" y2="704" x1="1536" />
        </branch>
        <iomarker fontsize="28" x="928" y="1072" name="clk" orien="R180" />
        <iomarker fontsize="28" x="960" y="1008" name="reset" orien="R180" />
        <iomarker fontsize="28" x="928" y="944" name="Data_in(31:0)" orien="R180" />
        <branch name="MIO_ready">
            <wire x2="1136" y1="1488" y2="1488" x1="992" />
            <wire x2="1136" y1="1152" y2="1488" x1="1136" />
            <wire x2="1312" y1="1152" y2="1152" x1="1136" />
        </branch>
        <branch name="mem_w">
            <wire x2="1792" y1="1344" y2="1344" x1="1776" />
            <wire x2="1792" y1="1344" y2="1360" x1="1792" />
            <wire x2="1840" y1="1360" y2="1360" x1="1792" />
        </branch>
        <iomarker fontsize="28" x="1840" y="1488" name="CPU_MIO" orien="R0" />
        <iomarker fontsize="28" x="1840" y="1360" name="mem_w" orien="R0" />
        <instance x="2128" y="1440" name="XLXI_2" orien="R0">
        </instance>
        <instance x="1312" y="1760" name="XLXI_1" orien="R0">
        </instance>
        <branch name="zero">
            <wire x2="1216" y1="1344" y2="1936" x1="1216" />
            <wire x2="2656" y1="1936" y2="1936" x1="1216" />
            <wire x2="1312" y1="1344" y2="1344" x1="1216" />
            <wire x2="2656" y1="1232" y2="1232" x1="2608" />
            <wire x2="2656" y1="1232" y2="1936" x1="2656" />
        </branch>
        <iomarker fontsize="28" x="2768" y="704" name="PC_out(31:0)" orien="R0" />
        <branch name="PC_out(31:0)">
            <wire x2="2768" y1="704" y2="704" x1="2608" />
        </branch>
        <branch name="XLXN_30">
            <wire x2="1936" y1="1152" y2="1152" x1="1776" />
            <wire x2="2128" y1="768" y2="768" x1="1936" />
            <wire x2="1936" y1="768" y2="1152" x1="1936" />
        </branch>
        <branch name="XLXN_32">
            <wire x2="2128" y1="1216" y2="1216" x1="1776" />
        </branch>
        <branch name="XLXN_33">
            <wire x2="2128" y1="1280" y2="1280" x1="1776" />
        </branch>
        <branch name="XLXN_34">
            <wire x2="2096" y1="1408" y2="1408" x1="1776" />
            <wire x2="2128" y1="1344" y2="1344" x1="2096" />
            <wire x2="2096" y1="1344" y2="1408" x1="2096" />
        </branch>
        <branch name="XLXN_35">
            <wire x2="2128" y1="1536" y2="1536" x1="1776" />
            <wire x2="2128" y1="1408" y2="1536" x1="2128" />
        </branch>
        <branch name="XLXN_36(1:0)">
            <wire x2="2064" y1="1600" y2="1600" x1="1776" />
            <wire x2="2128" y1="832" y2="832" x1="2064" />
            <wire x2="2064" y1="832" y2="1600" x1="2064" />
        </branch>
        <branch name="XLXN_37(2:0)">
            <wire x2="2048" y1="1664" y2="1664" x1="1776" />
            <wire x2="2048" y1="1152" y2="1664" x1="2048" />
            <wire x2="2128" y1="1152" y2="1152" x1="2048" />
        </branch>
        <branch name="XLXN_38(1:0)">
            <wire x2="1824" y1="1728" y2="1728" x1="1776" />
            <wire x2="1824" y1="1088" y2="1728" x1="1824" />
            <wire x2="2128" y1="1088" y2="1088" x1="1824" />
        </branch>
    </sheet>
</drawing>