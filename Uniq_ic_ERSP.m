function [ersp,outArr,times,freqs]=Uniq_ic_ERSP(EEG,comps,fnameout)

for ici=1:length(comps);
    
    icdat=zeros(size(EEG.icaact(1,:,:)));
    
    for i=1:length(comps{ici});
        m=comps{ici}(i)/abs(comps{ici}(i));
        icdat=icdat+EEG.icaact(abs(comps{ici}(i)),:,:)*m;
    end
        
    figure;[ersp(:,:,ici),itc,powbase,times,freqs,erspboot,itcboot,tfdata(:,:,:,ici)] = ...
                                newtimef(icdat, ...
                                         EEG.pnts, ...
                                         [EEG.xmin*1000 EEG.xmax*1000], ...
                                         EEG.srate, ...
                                         [1,.5], ...
                                         'freqs',[3 30], ...
                                         'timesout', -2);
end

outArr(:,:,1)=squeeze(mean(abs(tfdata(21,:,:,1)),1));
%outArr(:,:,2)=squeeze(mean(abs(tfdata(5,:,:,2)),1));

for ti=1:size(tfdata,3);
    y(:,:,ti,1)=angle(tfdata(:,:,ti,2))-angle(mean(tfdata(:,:,:,2),3));
end
ay=abs(y);
for ri=1:size(ay,1);
    for ci=1:size(ay,2);
        for pgi=1:size(ay,3);
            if ay(ri,ci,pgi)>pi;
                dy(ri,ci,pgi)=2*pi-ay(ri,ci,pgi);
            else
                dy(ri,ci,pgi)=ay(ri,ci,pgi);
            end
        end
    end
end
figure;surf(double(mean(dy,3)),'LineStyle','none');
outArr(:,:,2)=squeeze(dy(21,:,:));


outArr=zscore(outArr,[],2);
size(outArr)

cStr='rgb';
figure;hold on;
for epi=1:size(outArr,2);
    for i=1:size(outArr,3);
        plot(times,squeeze(outArr(:,epi,i)),cStr(i));
    end
end
save(fnameout,'outArr','-mat')