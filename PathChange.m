function Newpath = PathChange(Oldpath)

f = find(Oldpath =='\');
Newpath = '/global/workspace';
if size(f,2) == 1
    Newpath = [Newpath filesep Oldpath(4:end)];
elseif size(f,2)>=2
    for i = 2:size(f,2)
        pathsep = Oldpath(f(i-1)+1:f(i)-1);
        Newpath = [Newpath filesep pathsep];
    end
    Newpath = [Newpath filesep Oldpath(f(end)+1:end)];
else
    errordlg('Image Path Incorrect!');
end