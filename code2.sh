import Jenkins = require('jenkins');

const jenkins

Jenkins({ baseUrl: `https://${ username }:${ password }@${ urlToJenkinsInstance }`, crumbIssuer: true })
      .then((_jenkins) => {
        jenkins = _jenkins;

        return new Promise((resolve, reject) => {
          // start building a job
          jenkins.job.build({
            name: jobName,
            // put all the parameters here:
            parameters: {
              PARAM1: 'hello',
              PARAM2: 'world'
            }
          }, function (err, data) {
            if (err) { return reject(err); }

            resolve(data);
          });
        });
      })
      .then((queueId) => {
        console.log('job queueId: ', queueId);
      })
      .catch(printErrorAndExit);
