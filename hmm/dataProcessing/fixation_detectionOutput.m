function [fixation_list_t2,fixation_list_3s]=fixation_detectionOutput(data,t1,t2,minDur)
%load data from filecdata=load(data);
x=data(:,1);
y=data(:,2);
t=data(:,3);
n=length(t);
%build initial fixations list
%categorize each data point to a fixation cluster according to tolerance 1
fixations=[data,zeros(n,1)];
%initialize pointers
fixid=1; %fixation id
fixpointer=1; %fixations pointer
for i=1:n
    mx=mean(x(fixpointer:i));
    my=mean(y(fixpointer:i));
    d=distance2p(mx,my,x(i),y(i));
    if d>t1
        fixid=fixid+1;
        fixpointer=i;
    end
    fixations(i,4)=fixid;
end
%end of clustering according to tolerance 1
%number of fixation after clustering (t1)
number_fixations=fixations(n,4);

%initialize fixations list according spatial criteria
%(Center x, Center y, Number of data points after t1, Number of data points
%after second criterion, Start time, End time, Duration)
fixation_list_t2=zeros(1,7);
fixation_list_3s=zeros(1,7);

%initialize the list of points which are not participate in fixation analysis
list_of_out_points=[0 0 0 -1];

%print fixation list according to spatial criteria
for i=1:number_fixations
    [centerx_t2,centery_t2,n_t1_t2,n_t2,t1_t2,t2_t2,d_t2,out_points]=fixations_t2(fixations,i,t2);
    [centerx_3s,centery_3s,n_t1_3s,n_3s,t1_3s,t2_3s,d_3s]=fixations_3s(fixations,i);
    %build list(t2)
    fixation_list_t2(i,1)=centerx_t2;
    fixation_list_t2(i,2)=centery_t2;
    fixation_list_t2(i,3)=n_t1_t2;
    fixation_list_t2(i,4)=n_t2;
    fixation_list_t2(i,5)=t1_t2;
    fixation_list_t2(i,6)=t2_t2;
    fixation_list_t2(i,7)=d_t2;
    %build list(3s)
    fixation_list_3s(i,1)=centerx_3s;
    fixation_list_3s(i,2)=centery_3s;
    fixation_list_3s(i,3)=n_t1_3s;
    fixation_list_3s(i,4)=n_3s;
    fixation_list_3s(i,5)=t1_3s;
    fixation_list_3s(i,6)=t2_3s;
    fixation_list_3s(i,7)=d_3s;
    
    %build list of points which are not used
    list_of_out_points=[list_of_out_points;out_points];
end

%remove from list of out points the zeros records
n_out=size(list_of_out_points);
n_out=n_out(1,1);
list=zeros(1,4);
for i=1:n_out
    if list_of_out_points(i,4)==0
    list=[list;list_of_out_points(i,:)];
    end
end
n_list=size(list);
n_list=n_list(1,1);
if n_out>1
    list_of_out_points=list(2:n_list,:);
else
    list_of_out_points=0;
end

%applying duration threshold
fixation_list_t2=min_duration(fixation_list_t2,minDur);
fixation_list_3s=min_duration(fixation_list_3s,minDur);