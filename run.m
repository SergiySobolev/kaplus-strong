fs = 44100;   % sampling rate
N = 80000;    % length of vector to compute
D = 100;      % delay line (or wavetable) length

% ******* Simple String Attenuation Filter ******* %

b = -0.99*[0.5 0.5];
z = 0;

% ******* Initialize delay lines ******* %

y = zeros(1,N);                  % initialize output vector
dline = 2 * rand(1, D) - 1.0;
ptr = 1;

% *************************************** %
%                                         %
%             Delay Line(d)               %
%    |-------------------------------|    %
%    ^                                    %
%  pointer                                %
%                                         %
%     >>--- pointer increments --->>      %
%                                         %
% *************************************** %
%
% The pointer initially points to the delay line output.
% We can take the output and calculate a new input value
% which is placed where the output was taken from.  The
% pointer is then incremented and the process repeated.

% ******* Run Loop Start ******* %

[z1, z2] = filter(b, 1, 3, 5);

for n = 1:N

  y(n) = dline(ptr);
  [dline(ptr), z] = filter(b, 1, y(n), z);
  
  % Increment Pointers & Check Limits

  ptr = ptr + 1;
  if ptr > D
    ptr = 1;
  end
end

% Scale soundfile if necessary
max(abs(y))
if max(abs(y)) > 0.95
  y = y./(max(abs(y))+0.1);
  disp('Scaled waveform');
end

% Clear Figure Window and Plot
clf
plot(y);
sound(y',fs);