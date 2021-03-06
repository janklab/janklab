classdef System
    %SYSTEM System-level utilities
    
    methods (Static)
        
        function out = getpid()
        %GETPID Get the process ID of this Matlab process
        %
        % out = jl.util.System.getPid()
        %
        % Returns the processId of this Matlab process as a double.
        runtimeBean = java.lang.management.ManagementFactory.getRuntimeMXBean();
        procName = char(runtimeBean.getName());
        procNumStr = regexprep(procName, '@.*', '');
        out = str2double(procNumStr);
        end
        
        function sleep(seconds, millis, nanos)
        %SLEEP Make the Matlab execution thread sleep for a given time
        %
        % jl.util.System.sleep(seconds, millis, nanos)
        %
        % Causes the Matlab execution thread to sleep (temporarily cease
        % execution) for a specified amount of time.
        %
        % Seconds, Millis, and Nanos are all scalar doubles, are all optional,
        % and all accept fractional values. The resulting requested sleep time
        % is rounded off to nanos.
        %
        % This is an alternative to calling Matlab's pause() function, which
        % depends on the global pause-enabled state.
        %
        % The sleep time always happens on the main Matlab execution thread.
        %
        % The actual sleep time is dependent on the precision and accuracy of
        % system timers and schedulers. It's unlikely your precision is actually
        % close to the nanosecond.
        if nargin < 1 || isempty(seconds);  seconds = 0;  end
        if nargin < 2 || isempty(millis);   millis = 0;   end
        if nargin < 3 || isempty(nanos);    nanos = 0;    end
        totalNanos = (seconds * 10^9) + (millis * 10^6) + nanos;
        totalMillis = floor(totalNanos / 10^6);
        additionalNanos = round(rem(totalMillis, 10^6));
        java.lang.Thread.sleep(totalMillis, additionalNanos);
        end
        
    end
    
    methods (Access = private)
        function this = System()
        %SYSTEM Private constructor to suppress helptext display
        end
    end
end