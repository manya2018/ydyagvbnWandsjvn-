classdef Equalizer < handle
properties (Constant = constant)
    freqArray = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000,16000];
end
properties (SetAcess = private,GetAcess = public)
    order = 64;
    fs = 44100;
end
properties(Acess = public)
    gain (10,1) {double}=ones(10,1);
end
properties (Acess = protected)
    bBank {double}
    initB {double} = []
end
methods
    function obj=Equalizer(order,fs) 
        obj.order = order;
        obj.fs=fs;
        obj.bBank = CreateFilters(obj, obj.freqArray, order, fs);
    end
    function bBank = CreateFilters(freqArray, order, fS)
        freqArrayNorm = freqArray/(fS/2);
        for k=1:length(freqArray)
                if k==1
                    mLow = [1, 1, 0, 0];
                    freqLow = [0, freqArrayNorm(1), 2*freqArrayNorm(1), 1];
                    bLow = fir2(order, freqLow, mLow);
                elseif k==length(freqArray)
                    mHigh = [0, 0, 1, 1];
                    freqHigh = [0, freqArrayNorm(end)/2, freqArrayNorm(end),1];
                    bBank(k,:) = fir2(order, freqHigh, mHigh);
                else
                    mBand = [0, 0, 1, 0, 0];
                    freqBand = [0, freqArrayNorm(k-1), freqArrayNorm(k),freqArrayNorm(k+1), 1];
                    bBank(k,:) = fir2(order, freqBand, mBand);
                end 
       end
end
end
 