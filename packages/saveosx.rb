package :saveosx do
  url = 'https://raw.githubusercontent.com/cmacrae/saveosx/master/bootstrap'
  runner "curl #{url} | /bin/bash"
  verify do has_executable 'pkgin' end
end
