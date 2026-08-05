import urllib.request
import json
import os

url = "https://api.github.com/repos/ContextualWisdomLab/aFIPC/actions/runs/31040775856/jobs"
req = urllib.request.Request(url)
with urllib.request.urlopen(req) as response:
    data = json.loads(response.read().decode())
    for job in data['jobs']:
        print(f"Job: {job['name']}, Status: {job['status']}, Conclusion: {job['conclusion']}")
        # print first few steps
        for step in job['steps']:
            if step['conclusion'] == 'failure':
                print(f"  Step failed: {step['name']}")
