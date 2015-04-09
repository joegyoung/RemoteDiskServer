pid = spawn 'ruby ./remotedicserver.rb '
Process.detach(pid) #tell the OS we're not interested in the exit status
