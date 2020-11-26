
int Count_columns(TString file_name){
    TString command1="head -n1 ";
    TString command2=file_name;
    TString command3="| awk  -F  ' '  '{print NF}' >& log.txt ";
    TString command="";
    command=command1+command2+command3;
    system(command);
     
    ifstream infile("log.txt");
    int n;
    infile>>n;
    system("rm -rf log.txt");
    
    return n;   
    
  
}

double string_double(TString s){
     
     double a;
     stringstream ss;
     ss<<s;
     ss>>a;
     return a;
  }

TString string_double(double a){

     TString s;
     stringstream ss;
     ss<<a;
     ss>>s;
    return s;
}


static int color[14]={1,2,3,4,5,6,7,8,9,12,28,30,38,46};

void draw(){
  
   TString data_file="data.txt";
  
   int num=Count_columns(data_file);
  // TH1D *h =new TH1D("h","Hist",100,0,3000);
    
   std::vector<TString> title(num);
   std::vector<TH1D *>  hist(num);  
   std::vector<double>  mean(num);
   std::vector<double>  resolution(num);

   ifstream infile(data_file);
   for(int i=0;i<num;i++){
   
       infile>>title[i];
       hist[i]=new TH1D(title[i],title[i],300,0,3000);  
   }

   int tmp_v;
   while(1)
   {
     infile>>tmp_v;
     if(infile.eof()){
      break;
     }
     hist[0]->Fill(tmp_v);      
     for(int k=1;k<num;k++){
            infile>>tmp_v;
            hist[k]->Fill(tmp_v); 

           }
 

   }  
     

   for(int i=0; i<num;i++){
      /* mean[i]=sqrt(hist[i]->GetMean());
       resolution[i]=hist[i]->GetStdDev();
       resolution[i]=resolution[i]/mean[i];
      */
       mean[i]=hist[i]->GetMean();
       hist[i]->SetLineColor(color[i]);
       Double_t scale = 1/hist[i]->Integral();
      // std::cout<<scale<<"  ";
       hist[i]->Scale(scale);
       hist[i]->Draw("HIST SAME");

    }

 double ymax=hist[0]->GetBinContent(hist[0]->GetMaximumBin());
 
  for(int i=1;i<num;i++){
       
      if ( ymax < hist[i]->GetBinContent(hist[i]->GetMaximumBin()))
          ymax=hist[i]->GetBinContent(hist[i]->GetMaximumBin());

      }



  hist[0]->GetYaxis()->SetRangeUser(0,ymax*1.1);
  hist[0]->SetTitle("C1");
  hist[0]->GetXaxis()->SetTitle("n_PE");
  hist[0]->GetYaxis()->SetTitle("PDF");
  hist[0]->SetStats(kFALSE);
  
 
   TLegend *leg=new TLegend(0.4,0.6,0.89,0.89);
  
   for(int i=0;i<num;i++){
     
     TString s=string_double(mean[i]);
     leg->AddEntry(hist[i],title[i]+" "+s,"f");
     
     }
      
    leg->Draw();

  /* double a=123.4;
   TString s="";
   stringstream ss;
   ss<<a;
   ss>>s;
   std::cout<<s;
  */
 //  std::cout<<num;


}
