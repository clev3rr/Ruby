def curry3(proc_or_lambda)     
  currier = ->(*collected_args) {                
    ->(*new_args) {                            
      all_args = collected_args + new_args       

      case all_args.length                        
      when 0...3                                
        currier.call(*all_args)              
      when 3                                      
        proc_or_lambda.call(*all_args)          
      else                                     
        proc_or_lambda.call(*all_args)          
      end
    }
  }

  currier.call()                              
end

sum3 = ->(a, b, c) { a + b + c }            
cur = curry3(sum3)                             

puts "--- Тести curry3(sum3) ---"              
puts "cur.call(1).call(2).call(3) = #{cur.call(1).call(2).call(3)}"   
puts "cur.call(1, 2).call(3)      = #{cur.call(1, 2).call(3)}"        
puts "cur.call(1).call(2, 3)      = #{cur.call(1).call(2, 3)}"      
puts "cur.call(1, 2, 3)           = #{cur.call(1, 2, 3)}"             

begin
  cur.call(1, 2, 3, 4)                        
rescue ArgumentError                              
  puts "cur.call(1, 2, 3, 4)       = ArgumentError (забагато аргументів)"  
end

f  = ->(a, b, c) { "#{a}-#{b}-#{c}" }             
cF = curry3(f)                                     

puts "cF.call('A').call('B','C') = #{cF.call('A').call('B', 'C')}"  
