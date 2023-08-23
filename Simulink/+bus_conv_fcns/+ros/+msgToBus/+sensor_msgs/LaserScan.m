function slBusOut = LaserScan(msgIn, slBusOut, varargin)
%#codegen
%   Copyright 2021-2022 The MathWorks, Inc.
    currentlength = length(slBusOut.Header);
    for iter=1:currentlength
        slBusOut.Header(iter) = bus_conv_fcns.ros.msgToBus.std_msgs.Header(msgIn.Header(iter),slBusOut(1).Header(iter),varargin{:});
    end
    slBusOut.Header = bus_conv_fcns.ros.msgToBus.std_msgs.Header(msgIn.Header,slBusOut(1).Header,varargin{:});
    slBusOut.AngleMin = single(msgIn.AngleMin);
    slBusOut.AngleMax = single(msgIn.AngleMax);
    slBusOut.AngleIncrement = single(msgIn.AngleIncrement);
    slBusOut.TimeIncrement = single(msgIn.TimeIncrement);
    slBusOut.ScanTime = single(msgIn.ScanTime);
    slBusOut.RangeMin = single(msgIn.RangeMin);
    slBusOut.RangeMax = single(msgIn.RangeMax);
    maxlength = length(slBusOut.Ranges);
    recvdlength = length(msgIn.Ranges);
    currentlength = min(maxlength, recvdlength);
    if (max(recvdlength) > maxlength) && ...
            isequal(varargin{1}{1},ros.slros.internal.bus.VarLenArrayTruncationAction.EmitWarning)
        diag = MSLDiagnostic([], ...
                             message('ros:slros:busconvert:TruncatedArray', ...
                                     'Ranges', msgIn.MessageType, maxlength, max(recvdlength), maxlength, varargin{2}));
        reportAsWarning(diag);
    end
    slBusOut.Ranges_SL_Info.ReceivedLength = uint32(recvdlength);
    slBusOut.Ranges_SL_Info.CurrentLength = uint32(currentlength);
    slBusOut.Ranges = single(msgIn.Ranges(1:slBusOut.Ranges_SL_Info.CurrentLength));
    if recvdlength < maxlength
    slBusOut.Ranges(recvdlength+1:maxlength) = 0;
    end
    maxlength = length(slBusOut.Intensities);
    recvdlength = length(msgIn.Intensities);
    currentlength = min(maxlength, recvdlength);
    if (max(recvdlength) > maxlength) && ...
            isequal(varargin{1}{1},ros.slros.internal.bus.VarLenArrayTruncationAction.EmitWarning)
        diag = MSLDiagnostic([], ...
                             message('ros:slros:busconvert:TruncatedArray', ...
                                     'Intensities', msgIn.MessageType, maxlength, max(recvdlength), maxlength, varargin{2}));
        reportAsWarning(diag);
    end
    slBusOut.Intensities_SL_Info.ReceivedLength = uint32(recvdlength);
    slBusOut.Intensities_SL_Info.CurrentLength = uint32(currentlength);
    slBusOut.Intensities = single(msgIn.Intensities(1:slBusOut.Intensities_SL_Info.CurrentLength));
    if recvdlength < maxlength
    slBusOut.Intensities(recvdlength+1:maxlength) = 0;
    end
end
