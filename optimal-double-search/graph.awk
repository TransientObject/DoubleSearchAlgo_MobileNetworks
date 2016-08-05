BEGIN {
  	s=0 ;  r=0 ; d=0 ; bits=0 ; pdr1=1
	print "Markers: true"    > "PDR.xg" 
	print "BoundBox: true"   > "PDR.xg" 
	print "Background: grey" > "PDR.xg" 
	print "0 0"              > "PDR.xg" 
	print "Markers: true"    > "DROP.xg"
	print "BoundBox: true"   > "DROP.xg"
	print "Background: grey" > "DROP.xg"
	print "0 0"              > "DROP.xg"
	print "Markers: true"    > "THROUGHPUT.xg"
	print "BoundBox: true"   > "THROUGHPUT.xg"
	print "Background: grey" > "THROUGHPUT.xg"
	print "0 0"              > "THROUGHPUT.xg"

      }

{
 if(FILENAME=="ctemp")
 {
  sd=$1
  ed=$2
  tim=$3
  itval=$4
  end=$5
 }
 if(FILENAME=="Trace.tr")
 {
  if($3<=end)
  { 
   if($3<=tim && $1=="s" && (int($31)==sd || ed==int($33)) && $19=="AGT" )
   {
     s++ ; print "siva"
   }
   else if($3<=tim && $1=="r" && (ed==int($33) || int($31)==sd) && $19=="AGT" )
   {
    r++ ;  bits=bits+($37*8) 
   }
   else if($3<=tim && $1=="d"  && (ed==int($33) || int($31)==sd)  && ($19=="RTR" || $19=="IFQ" )) 
   {
     d++ 
   }

   if($3>tim && ($1=="s"|| $1=="r" || $1=="d" ))
   { 
     if(r!=0 && s!=0) 
     {  pdr=r/s
	print tim " "pdr1 > "PDR.xg" 
	print tim " "d   > "DROP.xg"
	r=0 ; s=0 ; d=0 
     }
     if(tim!=0) 
     { 
	tput=bits/(itval *1000)
	print tim " "tput > "THROUGHPUT.xg"
	bits=0
     }

     tim=tim+itval		
   }
  }
 }
}

END {   
      if(r!=0 && s!=0) 
      { 
	s++
	pdr=r/s
	print tim " "pdr1 > "PDR.xg" 
	print tim " "d   > "DROP.xg"
	print tim " "tput > "THROUGHPUT.xg"
	r=0 ; s=0 ; d=0 ;bits=0
      }




    }
