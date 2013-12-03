module ReportsHelper
	def total_time_taken_report(user, mode)
		answers= user.score_boards.where(:exam_mode=>mode).collect(&:time_taken)
		time = answers.map{|x| x.to_i}.sum
				
		hours = time/3600.to_i
		minutes = (time/60 - hours * 60).to_i
		seconds = (time - (minutes * 60 + hours * 3600))
		return seconds
	end

	def qsortable(column, title=nil)
		title  ||= column.titleize
		css_class = column == sort_column ? "current #{sort_direction}" : nil
		direction =  column == sort_column && sort_direction =="asc" ? "desc" : "asc"
		link_to title, params.merge(:qcol => column, :qdir => direction, :page => nil), {:class=>css_class}
	end
end
