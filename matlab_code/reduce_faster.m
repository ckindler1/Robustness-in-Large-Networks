function [N_out, X_out] = reduce_faster(N, X_in)
%REDUCE Reduces a network to a targeted deficiency using
%get_potential_faster. X_in desincentivises repeated
%reductions in consecutive runs. X_out gives the reductions in each step.

def=deficiency(N);

X=zeros(size(X_in));
X_temp=X;

def_target=0;

del=0;

while def>def_target
    %find P_d for current network
    
    P=get_potential_faster(N);
    
    %disincentivice repeated reductions in consecutive runs
    
    P=P-del*X_in;
    
    %find highest potential reduction
    
    [v,I] = max(P(:));
    
    [s_1, s_2] = ind2sub(size(P),I);
    
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
    X_temp=X_temp+X;
    
    %find deficiency of current network
    
    def=deficiency(N);
    
    %adjust disincentive matrix impact
    
    del=max(del-1/def,0);
    
    disp(v);
    disp(s_1);
    disp(s_2);
    disp(def);
end

[N_out, X_out]=reduce(N,X_in);