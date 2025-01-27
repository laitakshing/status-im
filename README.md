

## Prerequisites

Before proceeding, ensure you have the following installed on your local machine:
- **Docker**: [Download and Install](https://docs.docker.com/desktop/setup/install/mac-install/).

If you are not using Docker:
- **Git**: [Download and install Git](https://git-scm.com/downloads).
- **DBT (Data Build Tool)**: [Install DBT](https://docs.getdbt.com/docs/installation).
- **PostgreSQL**: Running instance with access credentials.
- **Grafana**: [Download and install Grafana](https://grafana.com/docs/grafana/latest/installation/).
- **Python 3.7+**: Required for DBT.

---

## Installation

### 1. Clone the Repository

Use GitHub Desktop or the command line to clone the repository to your local machine.

**Using GitHub Desktop:**

1. Open **GitHub Desktop**.
2. Click on **File** > **Clone Repository**.
3. In the **URL** tab, enter: https://github.com/your-username/dbt-project-grafana-dashboard.git
4. Choose the local path where you want to clone the repository.
5. Click **Clone**.

**Using Command Line:**

```bash
git clone https://github.com/your-username/dbt-project-grafana-dashboard.git
cd dbt-project-grafana-dashboard
```
Replace your-username with your actual GitHub username.

### 2. Set Up all components

## Usage

* Deploy the container with `make run`
* Shutdown the containers with `make down`
* Build the dbt models with `make dbt-buidlt`
* Compile the dbt models with `make dbt-compile`

Once you clone the repo, please start the docker compose and check the log to see if all services are up and healthy

<img width="330" alt="image" src="https://github.com/user-attachments/assets/146b6ea5-c77f-4cb3-97ea-bfb9a2d3ccf1" />


I already download the data from recruitment.free.technology as CSV and include them into init.sql so the init setup will store the data into postgre

### 3. Check the Grafana Dashboards

1.	Open Grafana in Your Browser:
Navigate to http://localhost:3000 (replace localhost with your server’s IP/domain if different) and login as admin/Password!

2. Default Dashboard
The default dashboard should be shown once dbt completed, the json is located at grafana/dahsboards/dahsboard.json
![image](https://github.com/user-attachments/assets/37920c48-7423-4296-8826-c69a78a52815)

