set val(chan) Channel/WirelessChannel ;# channel type
set val(prop) Propagation/TwoRayGround ;# radio-propagation model
set val(netif) Phy/WirelessPhy ;# network interface type
set val(mac) Mac/802_11 ;# MAC type
set val(ifq) Queue/DropTail/PriQueue ;# interface queue type
set val(ll) LL ;# link layer type
set val(ant) Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50 ;# max packet in ifq
set val(nn) 50 ;# number of mobilenodes
set val(rp) DSDV ;# routing protocol
set val(x) 1000 ;# X dimension of topography
set val(y) 1000 ;# Y dimension of topography
set val(stop) 150 ;# time of simulation end
set ns [new Simulator]
set tracefd [open simple.tr w]
set namtrace [open simwrls.nam w]
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

$ns node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-channelType $val(chan) \
-topoInstance $topo \
-agentTrace ON \
-routerTrace ON \
-macTrace OFF \
-movementTrace ON

for {set i 0} {$i < $val(nn) } { incr i } {
set n($i) [$ns node]
}


$n(0) set X_ 347.0
$n(0) set Y_ 3.0
$n(0) set Z_ 0.0

$n(1) set X_ 345.0
$n(1) set Y_ 36.0
$n(1) set Z_ 0.0

$n(2) set X_ 330.0
$n(2) set Y_ 121.0
$n(2) set Z_ 0.0

$n(3) set X_ 316.0
$n(3) set Y_ 152.0
$n(3) set Z_ 0.0

$n(4) set X_ 246.0
$n(4) set Y_ 90.0
$n(4) set Z_ 0.0

$n(5) set X_ 379.0
$n(5) set Y_ 6.0
$n(5) set Z_ 0.0

$n(6) set X_ 194.534468688809
$n(6) set Y_ 242.219724781276
$n(0) set Z_ 0.000000000000
$n(7) set X_ 182.705107611293
$n(7) set Y_ 251.567214570469
$n(7) set Z_ 0.000000000000
$n(8) set X_ 68.010440595954
$n(8) set Y_ 463.150391316805
$n(8) set Z_ 0.000000000000
$n(9) set X_ 94.093259789841
$n(9) set Y_ 219.692821892935
$n(9) set Z_ 0.000000000000
$n(10) set X_ 472.881941208486
$n(10) set Y_ 375.886337059633
$n(10) set Z_ 0.000000000000
$n(11) set X_ 6.522235543613
$n(11) set Y_ 303.304206367413
$n(11) set Z_ 0.000000000000
$n(12) set X_ 277.192062967445
$n(12) set Y_ 118.113812307751
$n(12) set Z_ 0.000000000000
$n(13) set X_ 413.306603549927
$n(13) set Y_ 366.980218522224
$n(13) set Z_ 0.000000000000
$n(14) set X_ 424.564888190827
$n(14) set Y_ 202.436878720036
$n(14) set Z_ 0.000000000000
$n(15) set X_ 361.499110630670
$n(15) set Y_ 347.351064963504
$n(15) set Z_ 0.000000000000
$n(16) set X_ 497.543660804881
$n(16) set Y_ 54.116142158433
$n(16) set Z_ 0.000000000000
$n(17) set X_ 885.387674477099
$n(17) set Y_ 965.477684237845
$n(17) set Z_ 0.000000000000
$n(18) set X_ 297.583486395275
$n(18) set Y_ 267.978754998087
$n(18) set Z_ 0.000000000000
$n(19) set X_ 195.605593893203
$n(19) set Y_ 418.896572694762
$n(19) set Z_ 0.000000000000
$n(20) set X_ 821.228039175140
$n(20) set Y_ 491.235496750330
$n(20) set Z_ 0.000000000000
$n(21) set X_ 775.614258909544
$n(21) set Y_ 988.947379798874
$n(21) set Z_ 0.000000000000
$n(22) set X_ 900.970216468397
$n(22) set Y_ 124.645042215979
$n(22) set Z_ 0.000000000000
$n(23) set X_ 260.632680079806
$n(23) set Y_ 855.947893587212
$n(23) set Z_ 0.000000000000
$n(24) set X_ 235.430623397597
$n(24) set Y_ 784.951104379685
$n(24) set Z_ 0.000000000000
$n(25) set X_ 955.009923931692
$n(25) set Y_ 452.833743251259
$n(25) set Z_ 0.000000000000
$n(26) set X_ 857.341029897084
$n(26) set Y_ 980.130116021974
$n(26) set Z_ 0.000000000000
$n(27) set X_ 893.733582202481
$n(27) set Y_ 912.031551055276
$n(27) set Z_ 0.000000000000
$n(28) set X_ 549.317497587306
$n(28) set Y_ 923.789621598144
$n(28) set Z_ 0.000000000000
$n(29) set X_ 881.912258089927
$n(29) set Y_ 268.494008864917
$n(29) set Z_ 0.000000000000



set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $n(1) $tcp
$ns attach-agent $n(31) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 10.0 "$ftp start"

set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $n(31) $tcp
$ns attach-agent $n(43) $sink
$ns connect $tcp $sink


$ns at 0.0 "$n(0) label CH"
$ns at 0.0 "$n(1) label Source"




$ns at 10.0 "$n(5) setdest 785.0 228.0 5.0"
$ns at 13.0 "$n(26) setdest 700.0 20.0 5.0"
$ns at 15.0 "$n(14) setdest 115.0 85.0 5.0"


$ns at 73.0 "$n(2) delete-mark N2"
$ns at 73.0 "$n(2) add-mark N2 pink circle"
$ns at 124.0 "$n(11) delete-mark N11"
$ns at 124.0 "$n(11) add-mark N11 purple circle"
$ns at 103.0 "$n(5) delete-mark N5"
$ns at 103.0 "$n(5) add-mark N5 white circle"
$ns at 87.0 "$n(26) delete-mark N26"
$ns at 87.0 "$n(26) add-mark N26 yellow circle"
$ns at 92.0 "$n(14) delete-mark N14"
$ns at 92.0 "$n(14) add-mark N14 green circle"


for {set i 0} {$i < $val(nn)} { incr i } {
# 20 defines the node size for nam
$ns initial_node_pos $n($i) 100
}


for {set i 0} {$i < $val(nn) } { incr i } {
$ns at $val(stop) "$n($i) reset";
}


$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 150.01 "puts \"end simulation\" ; $ns halt"
proc stop {} {
global ns tracefd namtrace
$ns flush-trace
close $tracefd
close $namtrace
exec nam simwrls.nam &
}

$ns run 
