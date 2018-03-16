function [N_out, X_out] = reduce(N, X_in)
%REDUCE Reduces a network to target deficiency. X_in desincentivises repeated
%reductions in consecutive runs. X_out gives the reductions in each step.

def_start=deficiency(N);

X=zeros(size(X_in));
X_out=X;

def=def_start;

def_target=1;

del=1;

while def>def_target
    %find P_d and P_e for current network and weigh the according to
    %deficiency remaining
    
    [P_1,P_2]=get_potential_fast(N);
    P_d=P_2;
    P_e=P_2-P_1;
    
    if def>3
        a=1/log(def);
    else
        a=0.8;
    end
    
    P=P_d-a*P_e;
    
    %disincentivice repeated reductions in consecutive runs
    
    P=P-del*X_in;
    
    %find highest potential reduction
    
    [v,I] = max(P(:));
    
    [s_1, s_2] = ind2sub(size(P_2),I);
    
    if s_1==s_2
        N=remove_species(N,s_1);
    else
        N=merge_species(N,s_1,s_2);
    end
    
    %update disincentive matrices
    
    X_in(s_2,:)=X_in(s_2,:)+X_in(s_1,:);
    X_in(:,s_2)=X_in(:,s_2)+X_in(:,s_1);
    
    X_in(s_2,s_2)=X_in(s_2,s_2)-X_in(s_2,s_1);
    
    X_in(s_1,:)=[];
    X_in(:,s_1)=[];
    
    X(s_1,s_2)=1;
    X(s_2,s_1)=1;
    X_out=X_out+X;
    
    %find deficiency of current network
    
    def=deficiency(N);
    
    %adjust disincentive matrix impact
    
    del=max(del-1/def,0);
    
    disp(v);
    disp(s_1);
    disp(s_2);
    disp(def);
    
    
end

N_out=N;

%{

while true
    r_1=rank(N.Y);
    
    [P_1,P_2]=get_potential_fast(N);
    
    ind=find(P_1>0);
    
    for i=1:size(ind,1)
        ix=ind(i);
        [s_1, s_2] = ind2sub(size(P_1),ix);
        
        Y=N.Y;
        Y(s_2,:)=Y(s_2,:)+Y(s_1,:);
        Y(s_1,:)=[];
        
        r_2=rank(Y);
        r=r_2-r_1;
        
        x=P_1(s_1,s_2)-r;
        disp(x)
        if x>0
            if s_1==s_2
                N=remove_species(N,s_1);
            else
                N=merge_species(N,s_1,s_2);
            end
            
            def=deficiency(N);
            
            fprintf("s_1=%d\n",s_1);
            fprintf("s_2=%d\n",s_2);
            disp(def);
            disp("done")
            
            N_out=N;
        end
    end
    
    [v,I] = max(P_2(:));
    
    [s_1, s_2] = ind2sub(size(P_2),I);
    
    if s_1==s_2
        N=remove_species(N,s_1);
    else
        N=merge_species(N,s_1,s_2);
    end
    
    def=deficiency(N);
    
    disp(v);
    disp(s_1);
    disp(s_2);
    disp(def);
end

%}