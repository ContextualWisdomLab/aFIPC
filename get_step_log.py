import urllib.request
import json
import os

url = "https://api.github.com/repos/ContextualWisdomLab/aFIPC/actions/runs/31040775856/jobs"
req = urllib.request.Request(url)
with urllib.request.urlopen(req) as response:
    data = json.loads(response.read().decode())
    for job in data['jobs']:
        if job['conclusion'] == 'failure':
            job_id = job['id']
            log_url = f"https://api.github.com/repos/ContextualWisdomLab/aFIPC/actions/jobs/{job_id}/logs"
            try:
                log_req = urllib.request.Request(log_url)
                with urllib.request.urlopen(log_req) as log_response:
                    logs = log_response.read().decode()
                    print(logs[-2000:])
            except Exception as e:
                print(e)
