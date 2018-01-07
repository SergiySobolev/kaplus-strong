fs = 44100; 
duration = 3;
N = fs * duration;
K = 100;
decay = 0.98;

d = cos(linspace(1,2*pi));

snd = my_ksbuild(d,K,decay,N);

plot(snd);

hplayer = audioplayer(snd, fs); play(hplayer)

function k = my_ksbuild(f,M,decay,N) 
    r = zeros(1,N);
    for i=1:N
        index1 = mod(i-1,M) + 1;
        first = f(index1);
        index2 = mod(i,M) + 1;
        second = f(index2);        
        
        r(i) = decay*(first + second)/2;        
        f(index1) = r(i);      
    end
    k = r;    
end


