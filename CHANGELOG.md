# Changelog

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
