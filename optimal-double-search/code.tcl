#------------------------------------------- Tool Command Language (TCL)---------------------------------------

#-------------------------------Environmental Settings-----------------------------
		
 set nn                49               ;# number of mobilenodes
 set val(x)            1670		;#X co-ordinate value
 set val(y)            1200		;#Y co-ordinate value
 set rp                DSR
#---------------------------------- Simulator Object Creation----------------------

set ns_ [new Simulator]

#--------------------------- Trace File to record all the Events-------------------

set f [open Trace.tr w]
$ns_ trace-all $f
$ns_ use-newtrace

#----------------------------------- NAM Window creation--------------------------

set namtrace [open Nam.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)


# -------------------------------Topology Creation------------------------------

set topo [new Topography]
set rp DSR
$topo load_flatgrid $val(x) $val(y)

#--------------------------- General Operational Director-----------------------

create-god $nn
set god_ [create-god $nn]
# -----------------------------Node Configuration-------------------------------

$ns_ node-config  -adhocRouting $rp \
 		 -llType LL \
                 -macType Mac/802_11 \
                 -ifqType Queue/DropTail/PriQueue \
                 -ifqLen 500 \
                 -antType Antenna/OmniAntenna \
                 -propType Propagation/TwoRayGround \
                 -phyType Phy/WirelessPhy \
                 -channelType Channel/WirelessChannel \
                 -topoInstance $topo \
		 -agentTrace ON \
                 -routerTrace ON \
                 -macTrace ON \
                 -movementTrace ON \
                 -idlePower 1.2 \
		 -rxPower 1.0 \
		 -txPower 1.5 \
		 -sleepPower 0.000015 \
           	 -initialEnergy 200 \
                 -energyModel EnergyModel 
		 

#--------------------------------- Node Creation  -------------------------------      
source tmp
Phy/WirelessPhy set Pt_ 0.788
for {set i 0} {$i < $nn } {incr i} {
					set node_($i) [$ns_ node]
					if { [expr $i % 4] != 0 } { $node_($i) set X_ 030.0 ; $node_($i) set Y_ 030.0 } 
					if { [expr $i % 4] == 0 } { $node_($i) set X_ 930.0 ; $node_($i) set Y_ 930.0 }
					$node_($i) set Z_ 0.0
					$god_ new_node $node_($i)
					$ns_ initial_node_pos $node_($i) 60
					$node_($i) color orange
				   } 

#--------------------------------- Sink Creation  ------------------------------- 

for {set i 0} {$i<$nn} {incr i} {
				  $ns_ at 0.0 "$node_($i) label-color orange"
				  set sink($i) [new Agent/TCPSink]
				  $ns_ attach-agent $node_($i) $sink($i)
				}


#----------------------- CBR Creation  ---------------------------------------- 

proc attach-CBR-traffic { node sink pk ivt } {
					   #Get an instance of the simulator
					   set ns_ [Simulator instance]
					   set reno [new Agent/TCP/Reno]
					   $ns_ attach-agent $node $reno
					   #Create a CBR  agent and attach it to the node
					   set cbr [new Application/Traffic/CBR]
					   $cbr attach-agent $reno
					   $cbr set packetSize_ $pk	;#sub packet size
					   $cbr set interval_ $ivt
					   #Attach CBR source to sink;
					   $ns_ connect $reno $sink
					   return $cbr
 				     }



#for {set i 0} {$i < $nn } {incr i} {  $ns_ at 0.001 "$node_($i)  setdest 480.632 480.686 1500" }

#--------------------------------- Node Deploy  -------------------------------- 

proc Deploy { tm tt nkt } {  
                   global ns_ node_ a nn

		   if { $nkt==0 } {
		   #------------- Random Value Generate -------------
		   if { $tt==1} {
						
		   #------ Execute number of time --------
  	           for { set i 0 } { $i<$nn } { incr i } {
		     set nt 1
		     #----- Repeat execuation-----
	             while { $nt } { 
				    set chk 1
				    set val [expr int(rand()*$nn)] ; #--- Random value Generate ----
				    if {  $val <$nn } { 
 							#----- Check Duplicate Value --------
						 	for { set j 0 } { $j<$i } { incr j} { if { $val==$a($j) } { set chk 0 } }
							#----- Store In Array ---------------
							if { $chk==1 } {  set a($i) $val  ;  set nt 0  } 
						      }
				}
						        }  
				  }  
			

			 set rr [open "Route_Req" w]
                         puts $rr "----------------------------------------------"
			 puts $rr "Node\tQueue_Lemgth\tMobility"
                         puts $rr "----------------------------------------------"
			 for { set i 0} { $i<49 } { incr i } { 
			 set nt 1
	                 while { $nt } { 
				  	  set chk 1
				    	  set val [expr int(rand()*500)] ; 
				    	  #set val1 [expr int(rand()*20)] ; 
				           if { $val >50 && $val <500 } { puts $rr "$i\t  $val\t\t $a($i)" ; set nt 0 } 
				       }
				                              } 
			 close $rr
			#---------------------- Random Node Deploy  ---------------
                        

			$ns_ at $tm "$node_($a(0))  setdest 1194.63 864.686 2000"
			$ns_ at $tm "$node_($a(1))  setdest 05.889  897.421 2000"
			$ns_ at $tm "$node_($a(2))  setdest 192.526 867.723 2000"
			$ns_ at $tm "$node_($a(3))  setdest 403.681 878.145 2000"
			$ns_ at $tm "$node_($a(4))  setdest 566.131 861.195 2000"
			$ns_ at $tm "$node_($a(5))  setdest 786.770 891.176 2000"
			$ns_ at $tm "$node_($a(6))  setdest 1018.25 877.490 2000"
			$ns_ at $tm "$node_($a(7))  setdest 07.112  743.439 2000"
			$ns_ at $tm "$node_($a(8))  setdest 183.387 723.714 2000"
			$ns_ at $tm "$node_($a(9))  setdest 396.864 726.312 2000"
			$ns_ at $tm "$node_($a(10)) setdest 600.249 722.778 2000"
			$ns_ at $tm "$node_($a(11)) setdest 780.595 744.345 2000"
			$ns_ at $tm "$node_($a(12)) setdest 978.030 742.895 2000"
			$ns_ at $tm "$node_($a(13)) setdest 028.024 594.853 2000"
			$ns_ at $tm "$node_($a(14)) setdest 210.162 595.741 2000"
			$ns_ at $tm "$node_($a(15)) setdest 397.493 591.160 2000"
			$ns_ at $tm "$node_($a(16)) setdest 604.486 578.724 2000"
			$ns_ at $tm "$node_($a(17)) setdest 833.068 602.543 2000"
			$ns_ at $tm "$node_($a(18)) setdest 1014.50 600.092 2000"
			$ns_ at $tm "$node_($a(19)) setdest 01.137  448.425 2000"
			$ns_ at $tm "$node_($a(20)) setdest 166.025 446.032 2000"
			$ns_ at $tm "$node_($a(21)) setdest 420.372 443.229 2000"
			$ns_ at $tm "$node_($a(22)) setdest 613.236 437.806 2000"
			$ns_ at $tm "$node_($a(23)) setdest 813.173 464.223 2000"
			$ns_ at $tm "$node_($a(24)) setdest 1008.39 460.157 2000"
			$ns_ at $tm "$node_($a(25)) setdest 018.729 312.913 2000"
			$ns_ at $tm "$node_($a(26)) setdest 200.299 313.954 2000"
			$ns_ at $tm "$node_($a(27)) setdest 389.457 314.250 2000"
			$ns_ at $tm "$node_($a(28)) setdest 594.978 305.736 2000"
			$ns_ at $tm "$node_($a(29)) setdest 770.954 328.334 2000"
			$ns_ at $tm "$node_($a(30)) setdest 982.254 323.374 2000"
			$ns_ at $tm "$node_($a(31)) setdest 06.106  167.062 2000"
			$ns_ at $tm "$node_($a(32)) setdest 193.068 172.333 2000"
			$ns_ at $tm "$node_($a(33)) setdest 418.951 185.829 2000"
			$ns_ at $tm "$node_($a(34)) setdest 618.363 167.535 2000"
			$ns_ at $tm "$node_($a(35)) setdest 833.363 190.643 2000"
			$ns_ at $tm "$node_($a(36)) setdest 1015.50 177.758 2000"
			$ns_ at $tm "$node_($a(37)) setdest 030.749 040.714 2000"
			$ns_ at $tm "$node_($a(38)) setdest 208.270 027.805 2000"
			$ns_ at $tm "$node_($a(39)) setdest 409.215 037.426 2000"
			$ns_ at $tm "$node_($a(40)) setdest 603.061 019.428 2000"
			$ns_ at $tm "$node_($a(41)) setdest 813.290 042.416 2000"
			$ns_ at $tm "$node_($a(42)) setdest 988.135 025.104 2000"
			$ns_ at $tm "$node_($a(43)) setdest 1160.26 719.847 2000"
			$ns_ at $tm "$node_($a(44)) setdest 1173.23 582.316 2000"
			$ns_ at $tm "$node_($a(45)) setdest 1168.41 444.810 2000"
			$ns_ at $tm "$node_($a(46)) setdest 1147.31 305.640 2000"
			$ns_ at $tm "$node_($a(47)) setdest 1185.58 162.339 2000"
			$ns_ at $tm "$node_($a(48)) setdest 1180.69 020.018 2000"
			}
		
		  #------------------------ Random Mobility ---------------------
		 if { $nkt==1 } {
			$ns_ at $tm "$node_($a(0))  setdest [expr (rand()*50)+1194.63] [expr (rand()*50)+ 864.686 ] $a(48)"
			$ns_ at $tm "$node_($a(1))  setdest [expr (rand()*50)+05.889 ] [expr (rand()*50)+ 897.421 ] $a(47)"
			$ns_ at $tm "$node_($a(2))  setdest [expr (rand()*50)+192.526] [expr (rand()*50)+ 867.723 ] $a(46)"
			$ns_ at $tm "$node_($a(3))  setdest [expr (rand()*50)+403.681] [expr (rand()*50)+ 878.145 ] $a(45)"
			$ns_ at $tm "$node_($a(4))  setdest [expr (rand()*50)+566.131] [expr (rand()*50)+ 861.195 ] $a(44)"
			$ns_ at $tm "$node_($a(5))  setdest [expr (rand()*50)+786.770] [expr (rand()*50)+ 891.176 ] $a(43)"
			$ns_ at $tm "$node_($a(6))  setdest [expr (rand()*50)+1018.25] [expr (rand()*50)+ 877.490 ] $a(42)"
			$ns_ at $tm "$node_($a(7))  setdest [expr (rand()*50)+07.112 ] [expr (rand()*50)+ 743.439 ] $a(41)"
			$ns_ at $tm "$node_($a(8))  setdest [expr (rand()*50)+183.387] [expr (rand()*50)+ 723.714 ] $a(40)"
			$ns_ at $tm "$node_($a(9))  setdest [expr (rand()*50)+396.864] [expr (rand()*50)+ 726.312 ] $a(39)"
			$ns_ at $tm "$node_($a(10)) setdest [expr (rand()*50)+600.249] [expr (rand()*50)+ 722.778 ] $a(38)"
			$ns_ at $tm "$node_($a(11)) setdest [expr (rand()*50)+780.595] [expr (rand()*50)+ 744.345 ] $a(37)"
			$ns_ at $tm "$node_($a(12)) setdest [expr (rand()*50)+978.030] [expr (rand()*50)+ 742.895 ] $a(36)"
			$ns_ at $tm "$node_($a(13)) setdest [expr (rand()*50)+028.024] [expr (rand()*50)+ 594.853 ] $a(35)"
			$ns_ at $tm "$node_($a(14)) setdest [expr (rand()*50)+210.162] [expr (rand()*50)+ 595.741 ] $a(34)"
			$ns_ at $tm "$node_($a(15)) setdest [expr (rand()*50)+397.493] [expr (rand()*50)+ 591.160 ] $a(33)"
			$ns_ at $tm "$node_($a(16)) setdest [expr (rand()*50)+604.486] [expr (rand()*50)+ 578.724 ] $a(32)"
			$ns_ at $tm "$node_($a(17)) setdest [expr (rand()*50)+833.068] [expr (rand()*50)+ 602.543 ] $a(31)"
			$ns_ at $tm "$node_($a(18)) setdest [expr (rand()*50)+1014.50] [expr (rand()*50)+ 600.092 ] $a(30)"
			$ns_ at $tm "$node_($a(19)) setdest [expr (rand()*50)+01.137 ] [expr (rand()*50)+ 448.425 ] $a(29)"
			$ns_ at $tm "$node_($a(20)) setdest [expr (rand()*50)+166.025] [expr (rand()*50)+ 446.032 ] $a(28)"
			$ns_ at $tm "$node_($a(21)) setdest [expr (rand()*50)+420.372] [expr (rand()*50)+ 443.229 ] $a(27)"
			$ns_ at $tm "$node_($a(22)) setdest [expr (rand()*50)+613.236] [expr (rand()*50)+ 437.806 ] $a(26)"
			$ns_ at $tm "$node_($a(23)) setdest [expr (rand()*50)+813.173] [expr (rand()*50)+ 464.223 ] $a(25)"
			$ns_ at $tm "$node_($a(24)) setdest [expr (rand()*50)+1008.39] [expr (rand()*50)+ 460.157 ] $a(24)"
			$ns_ at $tm "$node_($a(25)) setdest [expr (rand()*50)+018.729] [expr (rand()*50)+ 312.913 ] $a(23)"
			$ns_ at $tm "$node_($a(26)) setdest [expr (rand()*50)+200.299] [expr (rand()*50)+ 313.954 ] $a(22)"
			$ns_ at $tm "$node_($a(27)) setdest [expr (rand()*50)+389.457] [expr (rand()*50)+ 314.250 ] $a(21)"
			$ns_ at $tm "$node_($a(28)) setdest [expr (rand()*50)+594.978] [expr (rand()*50)+ 305.736 ] $a(20)"
			$ns_ at $tm "$node_($a(29)) setdest [expr (rand()*50)+770.954] [expr (rand()*50)+ 328.334 ] $a(19)"
			$ns_ at $tm "$node_($a(30)) setdest [expr (rand()*50)+982.254] [expr (rand()*50)+ 323.374 ] $a(18)"
			$ns_ at $tm "$node_($a(31)) setdest [expr (rand()*50)+06.106 ] [expr (rand()*50)+ 167.062 ] $a(17)"
			$ns_ at $tm "$node_($a(32)) setdest [expr (rand()*50)+193.068] [expr (rand()*50)+ 172.333 ] $a(16)"
			$ns_ at $tm "$node_($a(33)) setdest [expr (rand()*50)+418.951] [expr (rand()*50)+ 185.829 ] $a(15)"
			$ns_ at $tm "$node_($a(34)) setdest [expr (rand()*50)+618.363] [expr (rand()*50)+ 167.535 ] $a(14)"
			$ns_ at $tm "$node_($a(35)) setdest [expr (rand()*50)+833.363] [expr (rand()*50)+ 190.643 ] $a(13)"
			$ns_ at $tm "$node_($a(36)) setdest [expr (rand()*50)+1015.50] [expr (rand()*50)+ 177.758 ] $a(12)"
			$ns_ at $tm "$node_($a(37)) setdest [expr (rand()*50)+030.749] [expr (rand()*50)+ 040.714 ] $a(11)"
			$ns_ at $tm "$node_($a(38)) setdest [expr (rand()*50)+208.270] [expr (rand()*50)+ 027.805 ] $a(10)"
			$ns_ at $tm "$node_($a(39)) setdest [expr (rand()*50)+409.215] [expr (rand()*50)+ 037.426 ] $a(9)"
			$ns_ at $tm "$node_($a(40)) setdest [expr (rand()*50)+603.061] [expr (rand()*50)+ 019.428 ] $a(8)"
			$ns_ at $tm "$node_($a(41)) setdest [expr (rand()*50)+813.290] [expr (rand()*50)+ 042.416 ] $a(7)"
			$ns_ at $tm "$node_($a(42)) setdest [expr (rand()*50)+988.135] [expr (rand()*50)+ 025.104 ] $a(6)"
			$ns_ at $tm "$node_($a(43)) setdest [expr (rand()*50)+1160.26] [expr (rand()*50)+ 719.847 ] $a(5)"
			$ns_ at $tm "$node_($a(44)) setdest [expr (rand()*50)+1173.23] [expr (rand()*50)+ 582.316 ] $a(4)"
			$ns_ at $tm "$node_($a(45)) setdest [expr (rand()*50)+1168.41] [expr (rand()*50)+ 444.810 ] $a(3)"
			$ns_ at $tm "$node_($a(46)) setdest [expr (rand()*50)+1147.31] [expr (rand()*50)+ 305.640 ] $a(2)"
			$ns_ at $tm "$node_($a(47)) setdest [expr (rand()*50)+1185.58] [expr (rand()*50)+ 162.339 ] $a(1)"
			$ns_ at $tm "$node_($a(48)) setdest [expr (rand()*50)+1180.69] [expr (rand()*50)+ 020.018 ] $a(0)"
			}
		     }


 

#-------------------------- optimal double search algorithm -----------------------------------

proc nnode {  } { 
  		 global node_ ns_ nn
		 set r [open "NNode.tr" w]
		 puts $r "----------------------------------------------------------------------"
		 puts $r "Node\t\tNeighbors\tx-cor\ty-cor \tDistance"
		 puts $r "----------------------------------------------------------------------"	
	         for { set i 0 } { $i <$nn } {  incr i } { 
							 set k 0
		 					 set x1 [$node_($i) set X_]
							 set y1 [$node_($i) set Y_]
		              				 for { set j 0 } { $j <$nn } { incr j } {
							 set x2 [$node_($j) set X_]
							 set y2 [$node_($j) set Y_]
						   	 set dis [expr sqrt(pow([expr $x2 - $x1],2)+pow([expr $y2 - $y1],2))]
 							 if { $dis <240 && $i!= $j } { incr k ; set wt $i 
									    set x2 [expr int($x1)] ; set y2 [expr int($y1)]
							                    puts $r "$i\t\t $j\t\t$x2\t$y2\t$dis"  }  }
							 puts $r "Total_Neighbors $wt = $k"
							} 
		 close $r   
		}





#-------------------------------- Give Color and Label ------------------------------


$ns_ at 1.0  "nnode"

#for {set i 1} {$i < 20 } {set i [expr $i+0.2]} {  $ns_ at [expr $i+0.1]"Deploy [expr $i+0.1] 0 1"  }

$ns_ color 0 blue

#---------------  Input File for Broadcast --------------------------	
				
set y [open "btemp" w]
puts $y "0 49 1.3 0.01 0 orange"
close $y

#$ns_ at 1.2 "exec awk -f S_broadcast.awk btemp NNode.tr"
#$ns_ at 1.3 "source S_broadcast.tcl"

#---------------  Input File for Shortest Path --------------------------

set y [open "atemp" w]
#puts $y "$sq1 $sq2 5.0 64 0.1 blue"
close $y

$ns_ at 4.5 "exec awk -f ShortRoute.awk atemp NNode.tr Route_Req"
#$ns_ at 4.8 "source Route.tcl"

#---------------  Input File for Graph --------------------------

set y [open "ctemp" w]
#puts $y "$sq1 $sq2 6.0 2 15"
close $y

#------------------------Finish Procedure to exec NAM Window----------------

proc distance { n1 n2 nd1 nd2} {
set nbr [open Neighbor a]
set x1 [expr int([$n1 set X_])]
set y1 [expr int([$n1 set Y_])]
set x2 [expr int([$n2 set X_])]
set y2 [expr int([$n2 set Y_])]
set d [expr int(sqrt(pow(($x2-$x1),2)+pow(($y2-$y1),2)))]
if {$d<250} {
if {$nd2!=$nd1} {
puts $nbr "\t$nd1\t\t$nd2\t\t\t$x1\t\t$y1\t\t$d"
}
}
close $nbr
}


set nbr [open Neighbor w]
puts $nbr "\t\t\t\t\tNeighbor Detail"
puts $nbr "\t~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
puts $nbr "\tSource\tNeighbor\tSX-Pos\t\tSY-Pos\t\tDistance(d)"
puts $nbr "\t~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
close $nbr


for {set i 0} {$i <$nn} {incr i} {
for {set j 0} {$j <$nn} {incr j} {
$ns_ at 1.5 "distance $node_($i) $node_($j) $i $j" 
}
}




set udp3 [$ns_ create-connection UDP $node_(20) LossMonitor $node_(14) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.0 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"



set udp3 [$ns_ create-connection UDP $node_(20) LossMonitor $node_(26) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.05 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 13.05 "$cbr2 start"
$ns_ at 15.05 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(20) LossMonitor $node_(21) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.05 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 8.05 "$cbr2 start"
$ns_ at 10.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(14) LossMonitor $node_(15) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.1 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
#$ns_ at 8.09 "$cbr2 start"
#$ns_ at 9.95 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(26) LossMonitor $node_(27) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.15 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 13.1 "$cbr2 start"
$ns_ at 15.05 "$cbr2 stop"









set udp3 [$ns_ create-connection UDP $node_(21) LossMonitor $node_(22) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.2 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 8.15 "$cbr2 start"
$ns_ at 10.0 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(20) LossMonitor $node_(15) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 10.0 "$cbr2 start"
$ns_ at 12.9 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(15) LossMonitor $node_(16) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.25 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 10.09 "$cbr2 start"
$ns_ at 12.05 "$cbr2 stop"




set udp3 [$ns_ create-connection UDP $node_(27) LossMonitor $node_(28) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.3 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 13.14 "$cbr2 start"
$ns_ at 15.05 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(22) LossMonitor $node_(23) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.35 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 8.2 "$cbr2 start"
$ns_ at 10.0 "$cbr2 stop"






set udp3 [$ns_ create-connection UDP $node_(16) LossMonitor $node_(17) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.4 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 10.11 "$cbr2 start"
$ns_ at 12.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(28) LossMonitor $node_(29) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.45 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 13.16 "$cbr2 start"
$ns_ at 15.05 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(23) LossMonitor $node_(24) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.5 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 8.25 "$cbr2 start"
$ns_ at 10.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(17) LossMonitor $node_(18) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.55 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 10.15 "$cbr2 start"
$ns_ at 12.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(18) LossMonitor $node_(45) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.55 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 10.18 "$cbr2 start"
$ns_ at 12.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(29) LossMonitor $node_(30) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.6 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 13.19 "$cbr2 start"
$ns_ at 15.05 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(24) LossMonitor $node_(45) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.65 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 8.35 "$cbr2 start"
$ns_ at 9.2 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(18) LossMonitor $node_(44) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.7 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
#$ns_ at 8.19 "$cbr2 start"
#$ns_ at 9.2 "$cbr2 stop"









set udp3 [$ns_ create-connection UDP $node_(30) LossMonitor $node_(46) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.75 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 13.23 "$cbr2 start"
$ns_ at 15.05 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(44) LossMonitor $node_(45) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.8 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
#$ns_ at 8.25 "$cbr2 start"
#$ns_ at 9.2 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(46) LossMonitor $node_(45) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 3.85 "$cbr2 start"
$ns_ at 4.0 "$cbr2 stop"
$ns_ at 13.29 "$cbr2 start"
$ns_ at 15.05 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(45) LossMonitor $node_(24) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 5.75 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(24) LossMonitor $node_(23) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 5.8 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"


set udp3 [$ns_ create-connection UDP $node_(23) LossMonitor $node_(22) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 5.9 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(22) LossMonitor $node_(21) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 5.95 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(21) LossMonitor $node_(20) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.05 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(45) LossMonitor $node_(44) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.25 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(45) LossMonitor $node_(46) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.35 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"
$ns_ at 15.35 "$cbr2 start"

set udp3 [$ns_ create-connection UDP $node_(44) LossMonitor $node_(17) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.45 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(46) LossMonitor $node_(29) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.55 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"
$ns_ at 15.39 "$cbr2 start"

set udp3 [$ns_ create-connection UDP $node_(17) LossMonitor $node_(16) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.6 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(29) LossMonitor $node_(28) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.65 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"
$ns_ at 15.41 "$cbr2 start"

set udp3 [$ns_ create-connection UDP $node_(16) LossMonitor $node_(15) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.75 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(28) LossMonitor $node_(27) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.8 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"
$ns_ at 15.45 "$cbr2 start"

set udp3 [$ns_ create-connection UDP $node_(15) LossMonitor $node_(14) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.85 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(27) LossMonitor $node_(26) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.9 "$cbr2 start"
$ns_ at 7.0 "$cbr2 stop"
$ns_ at 15.49 "$cbr2 start"

set udp3 [$ns_ create-connection UDP $node_(14) LossMonitor $node_(20) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.92 "$cbr2 start"
$ns_ at 7.1 "$cbr2 stop"

set udp3 [$ns_ create-connection UDP $node_(26) LossMonitor $node_(20) 0]
$udp3 set fid_ 1
$udp3 set class_ 1
set cbr2 [$udp3 attach-app Traffic/CBR]
$cbr2 set packetSize_ 512
$cbr2 set interval_ .05
$ns_ at 6.94 "$cbr2 start"
$ns_ at 7.1 "$cbr2 stop"

$ns_ at 15.53 "$cbr2 start"




$ns_ at 2.9 "$node_(20)  label  source"
$ns_ at 2.9 "$node_(45)  label  destination"


$ns_ at 0.01 "$node_(0) setdest 1194.0 864.0 2000.0"

			$ns_ at 0.01 "$node_(1)  setdest 05.889  897.421 2000"
			$ns_ at 0.01 "$node_(2)  setdest 192.526 867.723 2000"
			$ns_ at 0.01 "$node_(3)  setdest 403.681 878.145 2000"
			$ns_ at 0.01 "$node_(4)  setdest 566.131 861.195 2000"
			$ns_ at 0.01 "$node_(5)  setdest 786.770 891.176 2000"
			$ns_ at 0.01 "$node_(6)  setdest 1018.25 877.490 2000"
			$ns_ at 0.01 "$node_(7)  setdest 07.112  743.439 2000"
			$ns_ at 0.01 "$node_(8)  setdest 183.387 723.714 2000"
			$ns_ at 0.01 "$node_(9)  setdest 396.864 726.312 2000"
			$ns_ at 0.01 "$node_(10) setdest 600.249 722.778 2000"
			$ns_ at 0.01 "$node_(11) setdest 780.595 744.345 2000"
                        $ns_ at 0.01 "$node_(12) setdest 978.030 742.895 2000"
			$ns_ at 0.01 "$node_(13) setdest 028.024 594.853 2000"
			$ns_ at 0.01 "$node_(14) setdest 210.162 595.741 2000"
			$ns_ at 0.01 "$node_(15) setdest 397.493 591.160 2000"
			$ns_ at 0.01 "$node_(16) setdest 604.486 578.724 2000"
			$ns_ at 0.01 "$node_(17) setdest 833.068 602.543 2000"
			$ns_ at 0.01 "$node_(18) setdest 1014.50 600.092 2000"
			$ns_ at 0.01 "$node_(19) setdest 01.137  448.425 2000"
			$ns_ at 0.01 "$node_(20) setdest 166.025 446.032 2000"
			$ns_ at 0.01 "$node_(21) setdest 420.372 443.229 2000"
			$ns_ at 0.01 "$node_(22) setdest 613.236 437.806 2000"
			$ns_ at 0.01 "$node_(23) setdest 813.173 464.223 2000"
			$ns_ at 0.01 "$node_(24) setdest 1008.39 460.157 2000"
			$ns_ at 0.01 "$node_(25) setdest 018.729 312.913 2000"
			$ns_ at 0.01 "$node_(26) setdest 200.299 313.954 2000"
			$ns_ at 0.01 "$node_(27) setdest 389.457 314.250 2000"
			$ns_ at 0.01 "$node_(28) setdest 594.978 305.736 2000"
			$ns_ at 0.01 "$node_(29) setdest 770.954 328.334 2000"
			$ns_ at 0.01 "$node_(30) setdest 982.254 323.374 2000"
			$ns_ at 0.01 "$node_(31) setdest 06.106  167.062 2000"
			$ns_ at 0.01 "$node_(32) setdest 193.068 172.333 2000"
			$ns_ at 0.01 "$node_(33) setdest 418.951 185.829 2000"
			$ns_ at 0.01 "$node_(34) setdest 618.363 167.535 2000"
			$ns_ at 0.01 "$node_(35) setdest 833.363 190.643 2000"
			$ns_ at 0.01 "$node_(36) setdest 1015.50 177.758 2000"
			$ns_ at 0.01 "$node_(37) setdest 030.749 040.714 2000"
			$ns_ at 0.01 "$node_(38) setdest 208.270 027.805 2000"
			$ns_ at 0.01 "$node_(39) setdest 409.215 037.426 2000"
			$ns_ at 0.01 "$node_(40) setdest 603.061 019.428 2000"
			$ns_ at 0.01 "$node_(41) setdest 813.290 042.416 2000"
			$ns_ at 0.01 "$node_(42) setdest 988.135 025.104 2000"
			$ns_ at 0.01 "$node_(43) setdest 1160.26 719.847 2000"
			$ns_ at 0.01 "$node_(44) setdest 1173.23 582.316 2000"
			$ns_ at 0.01 "$node_(45) setdest 1168.41 444.810 2000"
			$ns_ at 0.01 "$node_(46) setdest 1147.31 305.640 2000"
			$ns_ at 0.01 "$node_(47) setdest 1185.58 162.339 2000"
			$ns_ at 0.01 "$node_(48) setdest 1180.69 020.018 2000"

# For mobility
proc mobility {tm} {
global ns_ node_
$ns_ at $tm "$node_(0) setdest [expr rand()*70+225.770] [expr rand()*70+567.415] [expr int(rand()*8)]"
$ns_ at $tm "$node_(1) setdest [expr rand()*70+244.963] [expr rand()*70+777.108] [expr int(rand()*8)]"
$ns_ at $tm "$node_(2) setdest [expr rand()*70+406.647] [expr rand()*70+832.137] [expr int(rand()*8)]"
$ns_ at $tm "$node_(3) setdest [expr rand()*70+530.831] [expr rand()*70+719.206] [expr int(rand()*8)]"
$ns_ at $tm "$node_(4) setdest [expr rand()*70+649.352] [expr rand()*70+830.773] [expr int(rand()*8)]"
$ns_ at $tm "$node_(5) setdest [expr rand()*70+385.442] [expr rand()*70+674.683] [expr int(rand()*8)]"
$ns_ at $tm "$node_(6) setdest [expr rand()*70+334.040] [expr rand()*70+502.696] [expr int(rand()*8)]"
$ns_ at $tm "$node_(7) setdest [expr rand()*70+514.330] [expr rand()*70+518.725] [expr int(rand()*8)]"
$ns_ at $tm "$node_(8) setdest [expr rand()*70+667.280] [expr rand()*70+610.471] [expr int(rand()*8)]"
$ns_ at $tm "$node_(9) setdest [expr rand()*70+803.674] [expr rand()*70+762.711] [expr int(rand()*8)]"

$ns_ at $tm "$node_(26) setdest [expr rand()*70+971.683] [expr rand()*70+678.476] [expr int(rand()*8)]"
$ns_ at $tm "$node_(11) setdest [expr rand()*70+929.517] [expr rand()*70+854.631] [expr int(rand()*8)]"
$ns_ at $tm "$node_(12) setdest [expr rand()*70+829.429] [expr rand()*70+566.669] [expr int(rand()*8)]"
$ns_ at $tm "$node_(13) setdest [expr rand()*70+657.973] [expr rand()*70+439.638] [expr int(rand()*8)]"
$ns_ at $tm "$node_(14) setdest [expr rand()*70+439.037] [expr rand()*70+374.831] [expr int(rand()*8)]"
$ns_ at $tm "$node_(15) setdest [expr rand()*70+585.519] [expr rand()*70+288.542] [expr int(rand()*8)]"
$ns_ at $tm "$node_(16) setdest [expr rand()*70+231.960] [expr rand()*70+358.172] [expr int(rand()*8)]"
$ns_ at $tm "$node_(17) setdest [expr rand()*70+212.719] [expr rand()*70+166.947] [expr int(rand()*8)]"
$ns_ at $tm "$node_(18) setdest [expr rand()*70+284.683] [expr rand()*70+016.476] [expr int(rand()*8)]"
$ns_ at $tm "$node_(19) setdest [expr rand()*70+368.587] [expr rand()*70+195.577] [expr int(rand()*8)]"

$ns_ at $tm "$node_(20) setdest [expr rand()*70+437.429] [expr rand()*70+013.669] [expr int(rand()*8)]"
$ns_ at $tm "$node_(21) setdest [expr rand()*70+493.069] [expr rand()*70+155.696] [expr int(rand()*8)]"
$ns_ at $tm "$node_(22) setdest [expr rand()*70+678.806] [expr rand()*70+166.085] [expr int(rand()*8)]"
$ns_ at $tm "$node_(23) setdest [expr rand()*70+620.357] [expr rand()*70+018.526] [expr int(rand()*8)]"
$ns_ at $tm "$node_(24) setdest [expr rand()*70+802.799] [expr rand()*70+338.616] [expr int(rand()*8)]"
$ns_ at $tm "$node_(25) setdest [expr rand()*70+945.119] [expr rand()*70+478.574] [expr int(rand()*8)]"
$ns_ at $tm "$node_(10) setdest [expr rand()*70+1097.673] [expr rand()*70+636.153] [expr int(rand()*8)]"
$ns_ at $tm "$node_(27) setdest [expr rand()*70+1097.357] [expr rand()*70+826.526] [expr int(rand()*8)]"
$ns_ at $tm "$node_(28) setdest [expr rand()*70+1238.119] [expr rand()*70+732.57] [expr int(rand()*8)]"
$ns_ at $tm "$node_(29) setdest [expr rand()*70+1228.719] [expr rand()*70+544.47] [expr int(rand()*8)]"

$ns_ at $tm "$node_(30) setdest [expr rand()*70+1104.407] [expr rand()*70+422.378] [expr int(rand()*8)]"
$ns_ at $tm "$node_(31) setdest [expr rand()*70+1259.960] [expr rand()*70+362.170] [expr int(rand()*8)]"
$ns_ at $tm "$node_(32) setdest [expr rand()*70+962.9600] [expr rand()*70+297.579] [expr int(rand()*8)]"
$ns_ at $tm "$node_(33) setdest [expr rand()*70+1133.224] [expr rand()*70+229.423] [expr int(rand()*8)]"
$ns_ at $tm "$node_(34) setdest [expr rand()*70+995.3630] [expr rand()*70+164.431] [expr int(rand()*8)]"
$ns_ at $tm "$node_(35) setdest [expr rand()*70+786.673] [expr rand()*70+011.153] [expr int(rand()*8)]"
$ns_ at $tm "$node_(36) setdest [expr rand()*70+842.950] [expr rand()*70+171.693] [expr int(rand()*8)]"
$ns_ at $tm "$node_(37) setdest [expr rand()*70+961.407] [expr rand()*70+011.378] [expr int(rand()*8)]"
$ns_ at $tm "$node_(38) setdest [expr rand()*70+1138.224] [expr rand()*70+024.423] [expr int(rand()*8)]"
$ns_ at $tm "$node_(39) setdest [expr rand()*70+1267.330] [expr rand()*70+136.72] [expr int(rand()*8)]"

$ns_ at $tm "$node_(40) setdest [expr rand()*70+1366.407] [expr rand()*70+277.378] [expr int(rand()*8)]"
$ns_ at $tm "$node_(41) setdest [expr rand()*70+1384.960] [expr rand()*70+465.170] [expr int(rand()*8)]"
$ns_ at $tm "$node_(42) setdest [expr rand()*70+1371.960] [expr rand()*70+647.579] [expr int(rand()*8)]"
$ns_ at $tm "$node_(43) setdest [expr rand()*70+1503.224] [expr rand()*70+690.423] [expr int(rand()*8)]"
$ns_ at $tm "$node_(44) setdest [expr rand()*70+1369.363] [expr rand()*70+811.431] [expr int(rand()*8)]"
$ns_ at $tm "$node_(45) setdest [expr rand()*70+1498.673] [expr rand()*70+521.153] [expr int(rand()*8)]"
$ns_ at $tm "$node_(46) setdest [expr rand()*70+1498.950] [expr rand()*70+301.693] [expr int(rand()*8)]"
$ns_ at $tm "$node_(47) setdest [expr rand()*70+1485.407] [expr rand()*70+116.378] [expr int(rand()*8)]"
$ns_ at $tm "$node_(48) setdest [expr rand()*70+1361.224] [expr rand()*70+005.423] [expr int(rand()*8)]"
#$ns_ at $tm "$node_(49) setdest [expr rand()*70+1253.224] [expr rand()*70+031.423] [expr int(rand()*8)]"
}



for {set i 1.1} {$i<49} {set i [expr $i+7]} {
$ns_ at $i "mobility $i"
}

$ns_ at 1.5 "exec awk -f n.awk Trace.tr"			
$ns_ at 3.0 "$ns_ trace-annotate \" source node sends route request (RREQ)message(optimal double route search) to destination.....\""
proc finish {} {
		global ns_ namtrace  node_ a
		$ns_ flush-trace
		close $namtrace 
		exec awk -f graph.awk ctemp Trace.tr 
		exec ./nam -r 2m Nam.nam &
		exec xgraph   PDR2.xg -geometry 800x400 -t " PERFORMACE ANALYSIS" -x "NODES" -y "pdr" -bg white & 
                exec xgraph   Throughput1.xg  -geometry 800x400 -t " PERFORMACE ANALYSIS" -x "NODES" -y "kb/s" -bg white & 
                exec xgraph  ENERGY.xg   -geometry 800x400 -t "ENERGY CONSUMPTION" -x "time" -y "energy-consumption(mj)" -bg white & 
		exit 0
	       }
for { set i 0 } { $i < $nn} { incr i } {
        source g.tcl
}


$ns_ at 12.24 "finish"

puts "Start of simulation.."
$ns_ run
         



