function out=SimpleGC(fname,lg,w,srate,prestimpnts)

load(fname);
%regress second signal from first signal...
N=size(outArr,1);

for diri=1:2;
    if diri==1;
        sind(1)=1;
        sind(2)=2;
    else
        sind(1)=2;
        sind(2)=1;
    end
    for epi=1:size(outArr,2);
        
        S2=squeeze(outArr(:,epi,sind(2)));
        X=sum(S2);
        X2=sum(S2.^2);
        
        S1=squeeze(outArr(:,epi,sind(1)));
        Y=sum(S1);
        Y2=sum(S1.^2);
        
        XY=sum(S2.*S1);
        
        byx(epi)=(XY-(X*Y/N))/(X2-(X*X/N));
        ayx(epi)=(Y-(byx(epi)*X))/N;
        
        yp=byx(epi)*S1+ayx(epi);
        
        dataRes(:,epi)=S1-yp;
    end
    
    %calculate granger causality...
    for pnti=1:size(outArr,1);
        
        lgPnt=pnti+lg;
        if lgPnt+w>size(outArr,1);break;end
        
        y=squeeze(mean(outArr(lgPnt:lgPnt+w,:,sind(2)),1));
        X=[squeeze(mean(outArr(pnti:pnti+w,:,sind(2)),1));squeeze(mean(dataRes(pnti:pnti+w,:,1),1))];
        
        out(pnti,:,diri)=regress(y',X');
    end
end

%plot results...
figure;plot(squeeze(mean(outArr(:,:,1),2)),'r');
hold on;plot(squeeze(mean(outArr(:,:,2),2)),'g');


cStr='rgb';
figure;hold on;
for epi=1:size(outArr,2);
    for sigi=1:size(outArr,3);
        plot(squeeze(outArr(:,epi,sigi)),cStr(sigi));
    end
end

figure;plot(out(:,1,1),'Color',[1 .85 .85],'LineWidth',4);
hold on;plot(out(:,2,1),'Color',[1 0 0],'LineWidth',4);
plot(out(:,1,2),'Color',[.85 1 .85],'LineWidth',4);
plot(out(:,2,2),'Color',[0 1 0],'LineWidth',4);

EEG.data(1,:)=out(:,2,1);
EEG.data(2,:)=out(:,2,2);

EEG.chanlocs(1).labels='ACC';
EEG.chanlocs(2).labels='OCC';

EEG.NTrialsUsed=size(outArr,2);
EEG.nbchan=size(EEG.data,1);
EEG.pnts=size(EEG.data,2);
EEG.srate=srate;

ExportERPscoreFormat(EEG,fname,'','bfa',prestimpnts);


