
def reload(filename)  
    list=Array.new
    if(File.exist?(filename)) 
        file=File.open(filename)
        File.open(file).each { |line| list.push(line)} 
        file.close()
    end
    return list
    
end

def help
     
    helpstring="Usage :-
    $ ./todo add \"todo item\"  # Add a new todo
    $ ./todo ls               # Show remaining todos
    $ ./todo del NUMBER       # Delete a todo
    $ ./todo done NUMBER      # Complete a todo
    $ ./todo help             # Show usage
    $ ./todo report           # Statistics"

    puts(helpstring)
    
    
end
    

def add (task,filename)
    todoList=reload(filename)
    path=File.join(File.dirname(__FILE__), filename)
    file = File.open(path, "w")
    todoList.push(task)
    i=0
    while(i<todoList.length)
       file.puts ("#{todoList[i]}")
       i+=1
    end
    file.close();
    puts("Added todo: \"#{task}\"")
   
end

def del(number,filename)
    num=number.to_i
    todoList=reload(filename)
    if(num>0 and num<=todoList.length)
        path=File.join(File.dirname(__FILE__), filename)
        file = File.open(path, "w")
        todoList.delete_at(num-1)
        i=0
        while(i<todoList.length)
            file.puts ("#{todoList[i]}")
            i+=1
        end
        file.close()
        puts("Deleted todo ##{num}")
    else
        puts("Error: todo ##{num} does not exist. Nothing deleted.")
    end
    
end


def done(number,filename,dfilename)
    num=number.to_i
    todoList=reload(filename)
    if( num>0 and num<=todoList.length)
        path=File.join(File.dirname(__FILE__), filename)
        file = File.open(path, "w")
        path=File.join(File.dirname(__FILE__), dfilename)
        dfile = File.open(path, "a") 
        dfile.puts ("x #{Time.now.strftime("%Y-%m-%d")} #{todoList[num-1]}")
        todoList.delete_at(num-1)
        i=0
        while(i<todoList.length)
            file.puts ("#{todoList[i]}")
            i+=1
        end
        file.close()
   
        puts("Marked todo ##{num} as done.")
    else
        puts("Error: todo ##{num} does not exist.")
    end
end

def report(filename,dfilename)
    todoList=reload(filename)
    doneList=reload(dfilename)
    puts"#{Time.now.strftime("%Y-%m-%d")} Pending : #{todoList.length} Completed : #{doneList.length}"
 end

def html(filename)
    todoList=reload(filename)
    if todoList.length == 0
        puts "nope"
    else
       stringhtml= todoList.map{|line| "<li> #{line} </li>" }.join("\n")
       puts(stringhtml)
    end
end


def ls(filename)
    todoList=reload(filename)
    if todoList.length == 0
        puts "There are no pending todos!"
    else
        i=todoList.length-1
        while(i>=0)
        puts ("[#{i+1}] #{todoList[i]}")
        i-=1
        end
    end      
end


todoList=Array.new
doneList=Array.new

cmd=ARGV[0]
if(cmd=="add" or cmd=="ls" or cmd=="del" or cmd=="done" or cmd=="help" or cmd=="report" or cmd=="html" )
    
    case cmd
    when "add" 
        task=ARGV[1]
        unless task
            puts("Error: Missing todo string. Nothing added!")
        else
            add(task,"todo.txt")
        end
        
    
    when  "del"
        number=ARGV[1]
        unless number
            puts("Error: Missing NUMBER for deleting todo.")
        else
            del(number,"todo.txt")
        end
        
    when  "done"
        number=ARGV[1]
        unless number
            puts("Error: Missing NUMBER for marking todo as done.")
        else
            done(number,"todo.txt","done.txt")
        
        end        

    when  "ls"
        ls("todo.txt")    

    when  "help"
        help
    when  "report"
        report("todo.txt","done.txt")
        
    when "html"
        html("todo.txt")
    end  
else
    help

end

