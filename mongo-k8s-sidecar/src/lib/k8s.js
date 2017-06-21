var Client = require('node-kubernetes-client');
var config = require('./config');
var util = require("util");
var dns = require("dns");

fs = require('fs');

var readToken = fs.readFileSync('/var/run/secrets/kubernetes.io/serviceaccount/token');

var client = new Client({
  host: config.k8sROServiceAddress,
  namespace: config.namespace,
  protocol: 'https',
  version: 'v1',
  token: readToken
});

var getMongoPods = function getPods(done) {

	if (config.isDiscoverByDNS){
		var domain = config.k8sMongoServiceName +
			"." + config.namespace +
			".svc" +
			"." +config.k8sClusterDomain;
		dns.resolve4(domain, (err, addrs) => {
			if (err) {
				return done(err);
			}
			var pods = [];
			for (var i in addrs){
				var pod = {status:{podIP:addrs[i],phase:'Running'}, metadata: null}
				pods.push(pod)
			}
			return done(null, pods);
		});
	}
	else{
		client.pods.get(function (err, podResult) {
			if (err) {
				return done(err);
			}
			var pods = [];
			for (var j in podResult) {
				pods = pods.concat(podResult[j].items)
			}
			var labels = config.mongoPodLabelCollection;
			var results = [];
			for (var i in pods) {
				var pod = pods[i];
				if (podContainsLabels(pod, labels)) {
					results.push(pod);
				}
			}
			done(null, results);
		});
	}
};

var podContainsLabels = function podContainsLabels(pod, labels) {
  if (!pod.metadata || !pod.metadata.labels) return false;

  for (var i in labels) {
    var kvp = labels[i];
    if (!pod.metadata.labels[kvp.key] || pod.metadata.labels[kvp.key] != kvp.value) {
      return false;
    }
  }

  return true;
};

module.exports = {
  getMongoPods: getMongoPods
};