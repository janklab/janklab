function [outA, outB] = identityProxy(a, b)
%IDENTITYPROXY Proxy values for identity tests on a set of values
%
% [outA, outB] = identityProxy(a, b)
%
% Transforms the input arrays in to double arrays which can be used as proxy
% values for doing equality and ordering operations on the inputs. This is
% useful for implementing equality and ordering functions for composite types
% whose components are of heterogeneous types. The proxy values are all of the
% same primitive type, so they can all be concatenated and compared efficiently.
%
% The identity proxy values may contain NaNs, for inputs which were NaN.

if nargin < 2
    outA = identityProxySingle(a);
    return;
end

if ~isequal(class(a), class(b))
	error('jl:InvalidInput', 'Cannot compute identity proxy values for mixed types (%s and %s)',...
		class(a), class(b));
end

if isa(a, 'double')
	outA = a;
	outB = b;
	return;
elseif isnumeric(a)	
	outA = double(a);
	outB = double(b);
	% Handle possible underflow for 64-bit ints
	if isa(a, 'int64') || isa(a, 'uint64')
		checkA = cast(outA, class(a));
		checkB = cast(outB, class(a));
		if ~isequal(checkA, a) || ~isequal(checkB, b)
			% Underflow occurred. Fall back to using the UNIQUE trick
			[outA, outB] = jl.algo.identityProxyUsingUnique(a, b);
		end
	end
	return;
else
	% General fallback case: rely on UNIQUE to identify an ordered set of values
	[outA, outB] = jl.algo.identityProxyUsingUnique(a, b);
end

end

function out = identityProxySingle(x)
if isa(x, 'double')
    out = x;
elseif isnumeric(x)
    out = double(x);
	% Handle possible underflow for 64-bit ints
    if isa(x, 'int64') || isa(x, 'uint64')
        checkX = cast(out, class(x));
        if ~isequal(checkX, x)
			% Underflow occurred. Fall back to using the UNIQUE trick
            out = jl.algo.identityProxyUsingUnique(x);
        end
    end
else
    out = jl.algo.identityProxyUsingUnique(x);
end
end
