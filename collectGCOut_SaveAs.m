function collectGCOut(fNameIn,taskLab,fNameOut)

if isempty(fNameIn)
    [fNameIn,fPath]=uigetfile('*.bfa','Select ERPscore files:','MultiSelect','on');
end

fidOut=fopen(fNameOut,'w');

fprintf(fidOut,'%s\t',['fName_',taskLab]);
fprintf(fidOut,'%s\t',['accVal_',taskLab]);
fprintf(fidOut,'%s\t',['accLat_',taskLab]);
fprintf(fidOut,'%s\t',['occVal_',taskLab]);
fprintf(fidOut,'%s\r\n',['occLat_',taskLab]);

for fi=1:length(fNameIn);
    
    EEG = pop_ImportERPscoreFormat(fNameIn{fi}, fPath );
    EEG.setname='erp';
    EEG = eeg_checkset( EEG );
    
    t=0:EEG.pnts-1;
    t=t*1000/EEG.srate;
    t=t-800;
    
    [x,accBrd(1)]=findnear(t,100);
    [x,accBrd(2)]=findnear(t,600);
    [x,occBrd(1)]=findnear(t,-300);
    [x,occBrd(2)]=findnear(t,200);
    
    [accVal,accInd]=min(EEG.data(1,accBrd(1):accBrd(2)));
    accLat=t(accBrd(1)+accInd);
    
    [occVal,occInd]=min(EEG.data(2,occBrd(1):occBrd(2)));
    occLat=t(occBrd(1)+occInd);
    
    fprintf(fidOut,'%s\t',fNameIn{fi});
    fprintf(fidOut,'%6.3f\t',accVal);
    fprintf(fidOut,'%6.3f\t',accLat);
    fprintf(fidOut,'%6.3f\t',occVal);
    fprintf(fidOut,'%6.3f\r\n',occLat);
    
end
    
    
    
fclose('all')