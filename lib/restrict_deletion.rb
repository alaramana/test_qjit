module RestrictDeletion
	def delete 
    raise 'delete method is disabled.'
  end                   
  
  def destroy 
    raise 'destroy method is disabled.'
  end 
  
  module ClassMethods
    def delete_all
      raise 'delete_all method is disabled.'
    end

    def destroy_all
      raise 'destroy_all method is disabled.'
    end
  end
end
