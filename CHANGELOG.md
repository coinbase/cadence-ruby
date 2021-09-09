# Changelog
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
