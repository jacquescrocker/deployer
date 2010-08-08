# define stage tasks
stages.each do |stage_name|
  desc "Set the target stage to `#{stage_name}'."
  task(stage_name) do
    set :stage, stage_name.to_sym
    load "#{stage_dir}/#{stage_name}"
  end
end