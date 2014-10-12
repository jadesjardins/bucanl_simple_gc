function Uniq_ic_GFA(EEG,comps,fnameout)

t=1:EEG.pnts;
t=t*1000/EEG.srate;
t=t+1000*EEG.xmin;

sclperp=mean(EEG.data,3);

for ici=1:length(comps);
    proj_uniq(:,:,ici)=EEG.icawinv(:,comps(ici),:)*mean(EEG.icaact(comps(ici),:,:),3);
end

proj_sum=sum(proj_uniq,3);
proj_res=sclperp-proj_sum;

outArr(1,:)=var(sclperp,[],1);
outArr(2,:)=var(proj_uniq(:,:,1),[],1);
outArr(3,:)=var(proj_uniq(:,:,2),[],1);
outArr(4,:)=var(proj_res,[],1);

cStr='krgb';
figure;hold on;
for i=1:size(outArr,1);
	plot(t,squeeze(outArr(i,:)),cStr(i));
end
save(fnameout,'outArr','-mat');



