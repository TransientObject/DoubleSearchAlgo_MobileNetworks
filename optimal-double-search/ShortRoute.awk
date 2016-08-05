#----------------- Aho Weinberger Kernighan (AWK) -------------------------

BEGIN {
p=0
r=0
}
{

if(FILENAME=="atemp") 
 {
  src=$1
  des=$2
  tm=$3
  pks=$4
  itv=$5
  clr=$6
 }

if(FILENAME=="NNode.tr" )
 if($1==p) 
 {
  n[p,1]=$1
  n[p,2]=$3
  n[p++,3]=$4
 }

if(FILENAME=="Route_Req" )
  if($1==r)
  {
    met[r,1]=$2
    met[r,2]=$3
    met[r++,3]=$1
  }

}


END {
 
 #--------------------------------------- Get a Path --------------------------
 min=2500
 k=0
 desx=n[des,2]
 desy=n[des,3]
 a[0]=src
 for(hct=0;a[hct]!=des;hct++)
 {
  src=a[hct] # Alternative src node
  k=k+1
  mobi=50

  #------ Check number of time -----
  if(hct==5000)
  {
    print ""  > "Route.tcl"
    exit 0
    break
  }

  srcx=n[src,2]
  srcy=n[src,3]
  for(j=0;j<p;j++) # find all node Distances
   if(src!=j)
   { 
    x=n[j,2]
    y=n[j,3]
    srcd=int(sqrt(((x-srcx)^2)+((y-srcy)^2)))
    desd=int(sqrt(((x-desx)^2)+((y-desy)^2)))
    
    if(srcd<=220)
     if ( desd<min && met[j,2]<mobi && j!=a[0]) # Check high dist from src and low dis from des and low mobility
     {
        min=desd
	mobi=met[j,2]
	a[k]=j
     }
   }
 }
 a[k]=des

 #------- Get Minimum Queue Size in that path ---------

 min=500
 for(i=1;i<k;i++)
  for(j=0;j<r;j++)
    if(a[i]==met[j,3] && min> met[j,1])
       min=met[j,1]

 if(min<128)
   min=64
 else if(min>127 && min<256)
   min=128
 else if(min>255) 
   min=256

 flg1=0
 tt=1

for(t=0;t<=tt;t++)
{
  
 if(t==1)
 {
  #----- Set Stop Time -------
  if(flg1==1)
    itval=0.2
  else
    itval=10.0

  #------------------------ Communicate Source And Destination ---------------------

  print ("$ns_ at "tm+0.025" \"$ns_ trace-annotate \\\"Source - "a[0]" Communicate to Destination - "des",  Path is Elected based on Mobility\\\"\"") > "Route.tcl"

  fll=0
  if(a[k]==des)
   for(i=0;i<k;i++)
   {
    print "set inf"i" [attach-CBR-traffic $node_("a[i]") $sink("a[i+1]") "min" "itv"]" > "Route.tcl"
    print "$ns_ at "tm" \"$inf"i" start\"" > "Route.tcl"
    print "$ns_ at "tm+itval" \"$inf"i" stop\"" > "Route.tcl"
 
    if(a[i+1]!=des)
      print "$ns_ at "tm" \"$node_("a[i+1]") color "clr"\"" > "Route.tcl"

    tm=tm+0.01
    fll=1
   }

   if(a[k]!=des)
     print "$ns_ at "tm" \"finish\"" > "Route.tcl"
 }

 if(t!=1)
 {

  #------------------------ Get Congestion Node Randomly ---------------------
  if(k>2) 
  {
   chk=1
   while(chk==1)
   {
     byp=int(rand()*k)
     if(byp!=0)
      chk=0
   }
 
   #---------------- Get Bypass Node  ---------------
   temp=a[byp]
   bypx=n[a[byp],2]
   bypy=n[a[byp],3]

   pbypx=n[a[byp-1],2]
   pbypy=n[a[byp-1],3]

   sbypx=n[a[byp+1],2]
   sbypy=n[a[byp+1],3]

   for(j=0;j<p;j++) 
   { 
    flg=-1
    if(a[byp]!=j)
    {  
      x=n[j,2]
      y=n[j,3]
      dis=int(sqrt(((x-bypx)^2)+((y-bypy)^2)))
      pdis=int(sqrt(((x-pbypx)^2)+((y-pbypy)^2)))
      sdis=int(sqrt(((x-sbypx)^2)+((y-sbypy)^2)))

      if(dis<=240 && pdis<=240 && sdis<=240)
      {
       flg=1
       for(jj=0;jj<k;jj++)
       { 
         if(a[jj]==j)
           flg=0
       }
      }

      if (flg==1)
       bypn=j
    }
   }

   if(bypn=="")
   { 
    flg1=0
    #print "$ns_ at "tm+itval" \"finish\"" > "Route.tcl"
    #exit 0
   } 
   else
    flg1=1
  }
 }

 if(flg1==1 && t==1)
 {

  #------------ Replace Congestion Node ------------
  for(j=0;j<k;j++)
   if(a[j]==a[byp])
      a[j]=bypn
  
  tm=tm+itval+0.1
  itval=10.0
  
  #----------- Again Communicate Source And Destination -------------- 
  print "puts \"\nCongestion Occur... So Using By-Pass Node!!!\n\"" > "Route.tcl"
  print "#--------------------- Congestion Occur ------------------------------ " > "Route.tcl"
  print ("$ns_ at "tm+0.025" \"$ns_ trace-annotate \\\"Node - "temp" have Congestion , So Route Electe By-Pass Node - "bypn"\\\"\"") > "Route.tcl"

  if(fll==1)
   for(i=0;i<k;i++)
   {
    print "set in"i" [attach-CBR-traffic $node_("a[i]") $sink("a[i+1]") "min" "itv"]" > "Route.tcl"
    print "$ns_ at "tm" \"$in"i" start\"" > "Route.tcl"
    print "$ns_ at "tm+itval" \"$in"i" stop\"" > "Route.tcl"
    if(a[i+1]!=des)
      print "$ns_ at "tm" \"$node_("a[i+1]") color purple\"" > "Route.tcl"
    tm=tm+0.01
   }
 }
}

}
