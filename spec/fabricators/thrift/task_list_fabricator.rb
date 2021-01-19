require 'gen/thrift/cadence_types'

Fabricator(:task_list_thrift, from: CadenceThrift::TaskList) do
  name 'test-task-list'
end
