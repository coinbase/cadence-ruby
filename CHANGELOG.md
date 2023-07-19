# Changelog

## 0.1.21
- Add workflow id and activity id to workflow and activity logs

## 0.1.20
- Check activity id, type and input to detect non-deterministic workflow when applying history

## 0.1.19
- Add a new `#signal_workflow_execution` method to accept domain rather than workflow.

## 0.1.18
- Expose parent workflow info (ID and RunID) in Cadence::Metadata::Workflow object

## 0.1.17
- Add workflow decision task deserialization logic that is compatible with official go implementation

## 0.1.16
- Add activity task deserialization logic that is compatible with official go implementation

## 0.1.15
- Add rbi definition for Cadence::Crew

## 0.1.14
- Add a Crew implementation to fork and manage worker child processes

## 0.1.13
- Add methods for fetching workflow executions (`#list_open_workflow_executions` and `#list_closed_workflow_executions`)

## 0.1.12
- Restore previous workflow context after finished processing

## 0.1.11
- Update Testing::LocalWorkflowContext execute_activity method to fail the future when the activity fails. 

## 0.1.10
- Add :id and :domain to workflow context's metadata

## 0.1.9
- Fix regression with non-deterministic timer cancellation

## 0.1.8
- Fix issue with incorrect timer cancellation under certain circumstances
- Implement testing mode support for async timers

## 0.1.7
- Update RBI file to remove Thrift methods

## 0.1.6
- Add Metadata::Base#to_h for uniform metadata
- Implement hooks for Error handling
- Add Coveralls
- Update RBI file to cover all classes and methods

## 0.1.5
- Implement strategies for resetting workflows

## 0.1.4
- Fix a bug which prevented retry_policy from being passed as explicit options
- Make retry_policy options mergeable with the values in an Activity or a Workflow

## 0.1.3
- Expose Cadence::Activity::AsyncToken in RBI

## 0.1.2
- Make Cadence::Client initializable allowing to connect to multiple clusters from the same app

## 0.1.1
- Add thread pool support to workflow pollers

## 0.1.0
- Add basic non-determinism check for workflow replay
- Make worker thread count & poller TTL configurable
- Add support for fetching paginated workflow history
- Implement Cadence.terminate_workflow
- Add metrics to report latency between poller loops
