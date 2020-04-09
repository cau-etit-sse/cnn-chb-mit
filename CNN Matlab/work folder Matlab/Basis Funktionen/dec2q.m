
function y = dec2q(x,a,b,format)
% function y = dec2q(x,a,b,format)
% Input is a vector of decimal numbers and the output is the equivalent numbers in Qa.b format 
% in either binary or hex format where "a' is number of bits to the left of the
% binary point not including the sign bit, and 'b' is the number of bits to the
% right of the binary point.
% Input numbers outside the range are clipped
% An example of a Q0.15 (also called Q15) number is 1.100 0000 0000 0000 = -1 + 0.5 = -0.5.
% x (vector) input in decimal
% a (scalar) number of bits to the left of the binary point not including the sign bit
%              (optional, default a = 0)
% b (scalar) number of bits to the right of the binary point
%              (optional, dafault b = 15)
% format (string) format of the output 'bin' or 'hex' (optional, default 'hex')
% y (string matrix) output in Qa.b format (each output number on a row of the matrix)
% written by Joe Hoffbeck, 2/5/17
% default a = 0
if nargin < 2,
    a = 0;
end
if isempty(a),
    a = 0;
end
% default b = 15
if nargin < 3,
    b = 15;
end
if isempty(a),
    b = 15;
end
% default format = 'hex'
if nargin < 4,
    format = 'hex';
end
format = lower(format);  % convert to lower case (to accept 'HEX' or 'BIN')
if a < 0,
    error('dec2q: input a must be greater than or equal to 0')
end
if b < 0,
    error('dec2q: input b must be greater than or equal to 0')
end
if ~strcmp(format,'hex') & ~strcmp(format,'bin'),
    error('dec2q: format must be either ''hex'' or ''bin''')
end
N = a + b + 1;  % number of bits in output number
y = [];
for i = 1:length(x),
	% clip input to range of Qa.b
	if x(i) < -2^a,   
	    x(k) = -2^a;
	    disp('dec2q: input clipped (too small)')
	end
	if x(i) > 2^a - 2^-b,
	    x(i) = 2^a - 2^-b;
	    disp('dec2q: input clipped (too big)')
	end
	
	% scale input to an integer and convert to two's complement format
	if x(i) >= 0,
	    d = dec2bin(x(i)*2^b,N);  % if positive, convert to binary
	else
	    d = dec2bin(2^N - abs(x(i)*2^b),N);  % if negative, take two's complement and convert to binary
	end
	
	% convert to hex (if needed)
	if strcmp(format,'hex'),
        if round(N/4) ~= N/4,
            error('dec2q: hex output not supported for these values of a and b because the number of bits is not a multiple of 4')
        end
	    d = dec2hex(bin2dec(d),N/4);
	end
	y(i,:) = d;
end
y = char(y);
