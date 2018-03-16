function [ def ] = deficiency( N )
%DEFICIENCY retuns the deficiency of the network
def=rank(N.Lam)-rank(N.Y*N.Lam);