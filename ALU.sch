<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="kintex7" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="A(31:0)" />
        <signal name="B(31:0)" />
        <signal name="XLXN_17(31:0)" />
        <signal name="XLXN_18(31:0)" />
        <signal name="ALU_operation(2:0)" />
        <signal name="ALU_operation(2)" />
        <signal name="XLXN_24(31:0)" />
        <signal name="XLXN_32(31:0)" />
        <signal name="XLXN_40(31:0)" />
        <signal name="XLXN_41(31:0)" />
        <signal name="XLXN_42(31:0)" />
        <signal name="res(31:0)" />
        <signal name="S(32:0)" />
        <signal name="S(31:0)" />
        <signal name="overflow" />
        <signal name="zero" />
        <signal name="XLXN_48(31:0)" />
        <port polarity="Input" name="A(31:0)" />
        <port polarity="Input" name="B(31:0)" />
        <port polarity="Input" name="ALU_operation(2:0)" />
        <port polarity="Output" name="res(31:0)" />
        <port polarity="Output" name="overflow" />
        <port polarity="Output" name="zero" />
        <blockdef name="and32">
            <timestamp>2016-2-27T5:21:0</timestamp>
            <line x2="32" y1="-96" y2="-96" style="linewidth:W" x1="64" />
            <line x2="28" y1="-32" y2="-32" style="linewidth:W" x1="64" />
            <line x2="64" y1="-16" y2="-16" x1="144" />
            <line x2="64" y1="-16" y2="-112" x1="64" />
            <line x2="144" y1="-112" y2="-112" x1="64" />
            <arc ex="144" ey="-112" sx="144" sy="-16" r="48" cx="144" cy="-64" />
            <line x2="224" y1="-64" y2="-64" style="linewidth:W" x1="192" />
        </blockdef>
        <blockdef name="or32">
            <timestamp>2016-2-27T5:21:0</timestamp>
            <line x2="64" y1="-16" y2="-16" x1="128" />
            <arc ex="208" ey="-64" sx="128" sy="-16" r="88" cx="132" cy="-104" />
            <arc ex="128" ey="-112" sx="208" sy="-64" r="88" cx="132" cy="-24" />
            <line x2="236" y1="-64" y2="-64" style="linewidth:W" x1="208" />
            <line x2="64" y1="-112" y2="-112" x1="128" />
            <line x2="48" y1="-96" y2="-96" style="linewidth:W" x1="80" />
            <arc ex="64" ey="-112" sx="64" sy="-16" r="56" cx="32" cy="-64" />
            <line x2="48" y1="-32" y2="-32" style="linewidth:W" x1="80" />
        </blockdef>
        <blockdef name="ADC32">
            <timestamp>2016-2-27T5:21:0</timestamp>
            <line x2="48" y1="-256" y2="-256" style="linewidth:W" x1="64" />
            <line x2="48" y1="-128" y2="-128" style="linewidth:W" x1="64" />
            <line x2="64" y1="-224" y2="-300" x1="64" />
            <line x2="112" y1="-224" y2="-192" x1="64" />
            <line x2="112" y1="-160" y2="-192" x1="64" />
            <line x2="64" y1="-160" y2="-76" x1="64" />
            <line x2="224" y1="-76" y2="-140" x1="64" />
            <line x2="224" y1="-300" y2="-236" x1="64" />
            <line x2="224" y1="-140" y2="-236" x1="224" />
            <line x2="240" y1="-192" y2="-192" style="linewidth:W" x1="224" />
            <line x2="128" y1="-304" y2="-276" x1="128" />
        </blockdef>
        <blockdef name="xor32">
            <timestamp>2016-2-27T5:21:0</timestamp>
            <arc ex="80" ey="-112" sx="80" sy="-16" r="56" cx="48" cy="-64" />
            <line x2="80" y1="-112" y2="-112" x1="144" />
            <line x2="80" y1="-16" y2="-16" x1="144" />
            <arc ex="144" ey="-112" sx="224" sy="-64" r="88" cx="148" cy="-24" />
            <arc ex="60" ey="-112" sx="64" sy="-16" r="56" cx="32" cy="-64" />
            <arc ex="224" ey="-64" sx="144" sy="-16" r="88" cx="148" cy="-104" />
            <line x2="80" y1="-96" y2="-96" style="linewidth:W" x1="32" />
            <line x2="80" y1="-32" y2="-32" style="linewidth:W" x1="32" />
            <line x2="228" y1="-64" y2="-64" style="linewidth:W" x1="256" />
        </blockdef>
        <blockdef name="nor32">
            <timestamp>2016-2-27T5:21:0</timestamp>
            <line x2="64" y1="-112" y2="-112" x1="128" />
            <arc ex="64" ey="-112" sx="64" sy="-16" r="56" cx="32" cy="-64" />
            <line x2="64" y1="-16" y2="-16" x1="128" />
            <arc ex="208" ey="-64" sx="128" sy="-16" r="88" cx="132" cy="-104" />
            <arc ex="128" ey="-112" sx="208" sy="-64" r="88" cx="132" cy="-24" />
            <line x2="224" y1="-64" y2="-64" style="linewidth:W" x1="256" />
            <circle style="linewidth:W" r="8" cx="216" cy="-64" />
            <line x2="48" y1="-96" y2="-96" style="linewidth:W" x1="80" />
            <line x2="48" y1="-32" y2="-32" style="linewidth:W" x1="80" />
        </blockdef>
        <blockdef name="srl32">
            <timestamp>2016-2-27T5:21:0</timestamp>
            <rect width="184" x="64" y="-128" height="128" />
            <line x2="32" y1="-96" y2="-96" style="linewidth:W" x1="64" />
            <line x2="32" y1="-32" y2="-32" style="linewidth:W" x1="64" />
            <line x2="288" y1="-64" y2="-64" style="linewidth:W" x1="248" />
        </blockdef>
        <blockdef name="SignalExt_32">
            <timestamp>2016-2-27T5:21:0</timestamp>
            <line x2="76" y1="-32" y2="-32" x1="64" />
            <line x2="208" y1="-32" y2="-32" style="linewidth:W" x1="196" />
            <rect width="120" x="76" y="-52" height="40" />
        </blockdef>
        <blockdef name="MUX8T1_32">
            <timestamp>2016-2-27T5:21:0</timestamp>
            <rect width="68" x="12" y="-264" height="264" />
            <line x2="48" y1="-264" y2="-272" style="linewidth:W" x1="48" />
            <line x2="0" y1="-16" y2="-16" style="linewidth:W" x1="12" />
            <line x2="0" y1="-48" y2="-48" style="linewidth:W" x1="12" />
            <line x2="0" y1="-80" y2="-80" style="linewidth:W" x1="12" />
            <line x2="0" y1="-112" y2="-112" style="linewidth:W" x1="12" />
            <line x2="0" y1="-144" y2="-144" style="linewidth:W" x1="12" />
            <line x2="0" y1="-176" y2="-176" style="linewidth:W" x1="12" />
            <line x2="0" y1="-208" y2="-208" style="linewidth:W" x1="12" />
            <line x2="0" y1="-240" y2="-240" style="linewidth:W" x1="12" />
            <line x2="96" y1="-160" y2="-160" style="linewidth:W" x1="80" />
        </blockdef>
        <blockdef name="or_bit_32">
            <timestamp>2016-2-27T5:21:0</timestamp>
            <rect width="220" x="64" y="-104" height="112" />
            <line x2="32" y1="-48" y2="-48" style="linewidth:W" x1="64" />
            <arc ex="260" ey="-48" sx="180" sy="0" r="88" cx="184" cy="-88" />
            <line x2="116" y1="0" y2="0" x1="180" />
            <line x2="116" y1="-96" y2="-96" x1="180" />
            <arc ex="116" ey="-96" sx="116" sy="0" r="56" cx="84" cy="-48" />
            <arc ex="180" ey="-96" sx="260" sy="-48" r="88" cx="184" cy="-8" />
            <line x2="120" y1="-96" y2="-96" x1="184" />
            <line x2="88" y1="-80" y2="-80" x1="128" />
            <line x2="92" y1="-16" y2="-16" x1="132" />
            <line x2="304" y1="-48" y2="-48" x1="284" />
        </blockdef>
        <blockdef name="sll32">
            <timestamp>2019-10-7T11:36:46</timestamp>
            <rect width="256" x="64" y="-128" height="128" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <block symbolname="and32" name="ALU_U1">
            <blockpin signalname="XLXN_24(31:0)" name="res(31:0)" />
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
        </block>
        <block symbolname="or32" name="ALU_U2">
            <blockpin signalname="XLXN_32(31:0)" name="res(31:0)" />
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
        </block>
        <block symbolname="ADC32" name="ADC_32">
            <blockpin signalname="XLXN_17(31:0)" name="B(31:0)" />
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="ALU_operation(2)" name="C0" />
            <blockpin signalname="S(32:0)" name="S(32:0)" />
        </block>
        <block symbolname="xor32" name="ALU_U3">
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
            <blockpin signalname="XLXN_40(31:0)" name="res(31:0)" />
        </block>
        <block symbolname="nor32" name="ALU_U4">
            <blockpin signalname="XLXN_41(31:0)" name="res(31:0)" />
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
        </block>
        <block symbolname="srl32" name="ALU_U5">
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
            <blockpin signalname="XLXN_42(31:0)" name="res(31:0)" />
        </block>
        <block symbolname="SignalExt_32" name="Signal_32">
            <blockpin signalname="XLXN_18(31:0)" name="So(31:0)" />
            <blockpin signalname="ALU_operation(2)" name="S" />
        </block>
        <block symbolname="xor32" name="ALU_U7">
            <blockpin signalname="XLXN_18(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
            <blockpin signalname="XLXN_17(31:0)" name="res(31:0)" />
        </block>
        <block symbolname="MUX8T1_32" name="MUXALU">
            <blockpin signalname="ALU_operation(2:0)" name="s(2:0)" />
            <blockpin signalname="XLXN_48(31:0)" name="I7(31:0)" />
            <blockpin signalname="S(31:0)" name="I6(31:0)" />
            <blockpin signalname="XLXN_42(31:0)" name="I5(31:0)" />
            <blockpin signalname="XLXN_41(31:0)" name="I4(31:0)" />
            <blockpin signalname="XLXN_40(31:0)" name="I3(31:0)" />
            <blockpin signalname="S(31:0)" name="I2(31:0)" />
            <blockpin signalname="XLXN_32(31:0)" name="I1(31:0)" />
            <blockpin signalname="XLXN_24(31:0)" name="I0(31:0)" />
            <blockpin signalname="res(31:0)" name="o(31:0)" />
        </block>
        <block symbolname="or_bit_32" name="ALU_Zero">
            <blockpin signalname="zero" name="o" />
            <blockpin signalname="res(31:0)" name="A(31:0)" />
        </block>
        <block symbolname="sll32" name="XLXI_12">
            <blockpin signalname="A(31:0)" name="A(31:0)" />
            <blockpin signalname="B(31:0)" name="B(31:0)" />
            <blockpin signalname="XLXN_48(31:0)" name="res(31:0)" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1504" y="640" name="ALU_U1" orien="R0">
        </instance>
        <instance x="1504" y="1200" name="ADC_32" orien="R0">
        </instance>
        <instance x="1504" y="1344" name="ALU_U3" orien="R0">
        </instance>
        <instance x="1504" y="1568" name="ALU_U4" orien="R0">
        </instance>
        <instance x="1504" y="1776" name="ALU_U5" orien="R0">
        </instance>
        <instance x="1056" y="864" name="Signal_32" orien="R0">
        </instance>
        <instance x="1088" y="1136" name="ALU_U7" orien="R0">
        </instance>
        <branch name="A(31:0)">
            <wire x2="1488" y1="544" y2="544" x1="992" />
            <wire x2="1536" y1="544" y2="544" x1="1488" />
            <wire x2="1488" y1="544" y2="704" x1="1488" />
            <wire x2="1488" y1="704" y2="944" x1="1488" />
            <wire x2="1552" y1="944" y2="944" x1="1488" />
            <wire x2="1488" y1="944" y2="1248" x1="1488" />
            <wire x2="1536" y1="1248" y2="1248" x1="1488" />
            <wire x2="1488" y1="1248" y2="1472" x1="1488" />
            <wire x2="1552" y1="1472" y2="1472" x1="1488" />
            <wire x2="1488" y1="1472" y2="1680" x1="1488" />
            <wire x2="1536" y1="1680" y2="1680" x1="1488" />
            <wire x2="1488" y1="1680" y2="1888" x1="1488" />
            <wire x2="1584" y1="1888" y2="1888" x1="1488" />
            <wire x2="1552" y1="704" y2="704" x1="1488" />
        </branch>
        <branch name="B(31:0)">
            <wire x2="1424" y1="1744" y2="1744" x1="1040" />
            <wire x2="1536" y1="1744" y2="1744" x1="1424" />
            <wire x2="1424" y1="1744" y2="1952" x1="1424" />
            <wire x2="1584" y1="1952" y2="1952" x1="1424" />
            <wire x2="1120" y1="1104" y2="1104" x1="1072" />
            <wire x2="1072" y1="1104" y2="1312" x1="1072" />
            <wire x2="1424" y1="1312" y2="1312" x1="1072" />
            <wire x2="1536" y1="1312" y2="1312" x1="1424" />
            <wire x2="1424" y1="1312" y2="1536" x1="1424" />
            <wire x2="1552" y1="1536" y2="1536" x1="1424" />
            <wire x2="1424" y1="1536" y2="1744" x1="1424" />
            <wire x2="1536" y1="608" y2="608" x1="1424" />
            <wire x2="1424" y1="608" y2="768" x1="1424" />
            <wire x2="1424" y1="768" y2="1312" x1="1424" />
            <wire x2="1552" y1="768" y2="768" x1="1424" />
        </branch>
        <branch name="XLXN_17(31:0)">
            <wire x2="1552" y1="1072" y2="1072" x1="1344" />
        </branch>
        <branch name="XLXN_18(31:0)">
            <wire x2="1056" y1="960" y2="1040" x1="1056" />
            <wire x2="1120" y1="1040" y2="1040" x1="1056" />
            <wire x2="1328" y1="960" y2="960" x1="1056" />
            <wire x2="1328" y1="832" y2="832" x1="1264" />
            <wire x2="1328" y1="832" y2="960" x1="1328" />
        </branch>
        <iomarker fontsize="28" x="912" y="400" name="ALU_operation(2:0)" orien="R180" />
        <branch name="ALU_operation(2)">
            <attrtext style="alignment:SOFT-LEFT;fontsize:28;fontname:Arial" attrname="Name" x="1088" y="536" type="branch" />
            <wire x2="1088" y1="496" y2="832" x1="1088" />
            <wire x2="1120" y1="832" y2="832" x1="1088" />
            <wire x2="1088" y1="832" y2="880" x1="1088" />
            <wire x2="1632" y1="880" y2="880" x1="1088" />
            <wire x2="1632" y1="880" y2="896" x1="1632" />
        </branch>
        <bustap x2="1088" y1="400" y2="496" x1="1088" />
        <iomarker fontsize="28" x="1040" y="1744" name="B(31:0)" orien="R180" />
        <iomarker fontsize="28" x="992" y="544" name="A(31:0)" orien="R180" />
        <branch name="XLXN_24(31:0)">
            <wire x2="1968" y1="576" y2="576" x1="1728" />
            <wire x2="1968" y1="576" y2="800" x1="1968" />
            <wire x2="2192" y1="800" y2="800" x1="1968" />
        </branch>
        <instance x="1504" y="800" name="ALU_U2" orien="R0">
        </instance>
        <branch name="XLXN_40(31:0)">
            <wire x2="2000" y1="1280" y2="1280" x1="1760" />
            <wire x2="2000" y1="896" y2="1280" x1="2000" />
            <wire x2="2192" y1="896" y2="896" x1="2000" />
        </branch>
        <branch name="XLXN_41(31:0)">
            <wire x2="2048" y1="1504" y2="1504" x1="1760" />
            <wire x2="2048" y1="928" y2="1504" x1="2048" />
            <wire x2="2192" y1="928" y2="928" x1="2048" />
        </branch>
        <branch name="XLXN_42(31:0)">
            <wire x2="2096" y1="1712" y2="1712" x1="1792" />
            <wire x2="2096" y1="960" y2="1712" x1="2096" />
            <wire x2="2192" y1="960" y2="960" x1="2096" />
        </branch>
        <instance x="2384" y="1472" name="ALU_Zero" orien="R0">
        </instance>
        <iomarker fontsize="28" x="2576" y="880" name="res(31:0)" orien="R0" />
        <branch name="S(32:0)">
            <wire x2="1776" y1="1008" y2="1008" x1="1744" />
            <wire x2="1776" y1="992" y2="1008" x1="1776" />
            <wire x2="1792" y1="992" y2="992" x1="1776" />
            <wire x2="1792" y1="992" y2="1008" x1="1792" />
            <wire x2="1792" y1="1008" y2="1024" x1="1792" />
        </branch>
        <bustap x2="1888" y1="1008" y2="1008" x1="1792" />
        <branch name="res(31:0)">
            <wire x2="2384" y1="880" y2="880" x1="2288" />
            <wire x2="2384" y1="880" y2="1424" x1="2384" />
            <wire x2="2416" y1="1424" y2="1424" x1="2384" />
            <wire x2="2576" y1="880" y2="880" x1="2384" />
        </branch>
        <branch name="ALU_operation(2:0)">
            <wire x2="1088" y1="400" y2="400" x1="912" />
            <wire x2="2240" y1="400" y2="400" x1="1088" />
            <wire x2="2240" y1="400" y2="768" x1="2240" />
        </branch>
        <branch name="XLXN_32(31:0)">
            <wire x2="1760" y1="736" y2="736" x1="1744" />
            <wire x2="1760" y1="736" y2="832" x1="1760" />
            <wire x2="2192" y1="832" y2="832" x1="1760" />
        </branch>
        <instance x="2192" y="1040" name="MUXALU" orien="R0">
        </instance>
        <branch name="S(31:0)">
            <wire x2="1952" y1="1008" y2="1008" x1="1888" />
            <wire x2="2032" y1="1008" y2="1008" x1="1952" />
            <wire x2="2192" y1="864" y2="864" x1="1952" />
            <wire x2="1952" y1="864" y2="1008" x1="1952" />
            <wire x2="2032" y1="992" y2="1008" x1="2032" />
            <wire x2="2192" y1="992" y2="992" x1="2032" />
        </branch>
        <branch name="overflow">
            <wire x2="2864" y1="1824" y2="1824" x1="2672" />
        </branch>
        <iomarker fontsize="28" x="2864" y="1824" name="overflow" orien="R0" />
        <branch name="zero">
            <wire x2="2784" y1="1424" y2="1424" x1="2688" />
        </branch>
        <iomarker fontsize="28" x="2784" y="1424" name="zero" orien="R0" />
        <instance x="1584" y="1984" name="XLXI_12" orien="R0">
        </instance>
        <branch name="XLXN_48(31:0)">
            <wire x2="2112" y1="1888" y2="1888" x1="1968" />
            <wire x2="2112" y1="1024" y2="1888" x1="2112" />
            <wire x2="2192" y1="1024" y2="1024" x1="2112" />
        </branch>
    </sheet>
</drawing>