# raoulaime.github.io

Personal site of Raoul-Aimé Kengne, senior consultant and cloud & infrastructure architect: <https://raoulaime.github.io/>

This repository holds the **generated output only**. Please don't edit the HTML here: it is overwritten on every release.

## About me

Hi, I'm **Raoul-Aimé Kengne**. I live in Quebec City and I've spent the last 16 years building and running infrastructure for banks, government and telecoms, first in Cameroon and Morocco, now in Canada.

What I enjoy most is taking something that works only because one person remembers how, and turning it into something a whole team can rebuild from Git. Most of that work is on Red Hat platforms (OpenShift, Ansible Automation Platform, RHEL), AWS and Azure, and on clusters we build on-premises with VMware or KVM.

At home I run a small lab where I try things before I recommend them to anyone.

### What I do day to day

I'm a technical lead on Red Hat OpenShift (ROSA, ARO), the subject-matter expert and escalation point for highly secured enterprise environments. I design and review AWS and Azure architectures with reliability, scalability and cost in mind.

### Areas of work

- **Cloud and migration**: landing zone design, hybrid and multi-cloud, large-scale lift-and-shift migrations to AWS and Azure.
- **Platform engineering**: OpenShift in the cloud (ROSA, ARO) and on-premises on VMware and KVM, Kubernetes (AKS, EKS), GitOps with Argo CD, CI/CD pipeline design.
- **Automation and IaC**: Ansible Automation Platform (AAP/AWX), Terraform, Helm, Azure DevOps, GitHub Actions, Python.
- **Architecture and governance**: enterprise and technology architecture, integration, impact analysis, IT governance, technology risk.
- **Observability**: Prometheus, Grafana, Azure Monitor, AWS CloudWatch.
- **Systems**: RHEL, IBM AIX, Windows Server, VMware, Cisco, plus Oracle, Informix and SQL Server.

### Career highlights

- Architected an Ansible automation platform on two Azure Red Hat OpenShift clusters (AWX/AAP, Quay, Entra ID SSO) that provisions and configures roughly 1,800 servers.
- Operated the AWS Cloud Migration Factory and designed the network connectivity for a multi-account lift-and-shift to AWS.
- Migrated workloads to Azure for a provincial ministry and built the landing zone with Terraform and Azure DevOps.
- Moved Azure Bicep code to Terraform, and Ansible configurations to Helm charts, to make deployments easier to maintain.
- Moved banking operations from legacy scripts to Infrastructure as Code with Ansible, Terraform and Python.
- Led L3 major-incident resolution and DRP/BCP implementation at a pan-African banking technology hub.

### Education

- **Master's in Networks, Telecoms and Systems**, University of Dschang, Cameroon
- **Bachelor's in Network and Telecom Engineering**, IUT-FV, Bandjoun, Cameroon

## About the site

Three pages: **Home** (key numbers, what I do, selected projects), **About** and **Contact**.

- Light and dark mode: follows the system setting, with a manual toggle.
- Syntax highlighting with Chroma, copy button on code blocks.
- Tables turn into cards on small screens.
- Diagrams are hand-drawn SVGs, with the `.excalidraw` source next to each one.

## Where the source lives

The site is built with [Hugo](https://gohugo.io/) from [raoulaime/blog](https://github.com/raoulaime/blog), which contains:

- `content/`: the pages (Home, About, Contact)
- `data/home.yaml`: the home page text, stats and project cards
- `layouts/` and `static/`: a small custom theme (no dependencies, no JavaScript framework)
- `_parked/`: posts and diagrams set aside for later, with restore steps

## Build and publish

```bash
# in raoulaime/blog
hugo --destination /tmp/site
rsync -r --delete --exclude=.git --exclude=README.MD /tmp/site/ ../raoulaime.github.io/

# in raoulaime.github.io
git add -A && git commit -m "Rebuild site" && git push origin main
```

GitHub Pages serves the `main` branch of this repository.

## Contact

[LinkedIn](https://www.linkedin.com/in/raoulaime) · [GitHub](https://github.com/raoulaime)
