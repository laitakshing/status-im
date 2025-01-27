# BI Recruitment Task

This repo provide a set of preconfigured tools that can be used for the recruitment task for IFT:

* PostgreSQL database
* DBT
* Grafana

## Tasks

One goal of the BI team is to design and implement dashboards to help Projects Lead have an overview of their project.
Those dashboards will be use for the progress reporting, evaluating the project adoption, and identify improvement.

In the Database, you will find data extracted from one of our [Github Project](https://github.com/waku-org/) and wake financial data. With those, create some indicators concerning:
* Issues distribution.
* The activity on different repositories.
* The Cost of the project.

The github data are base on the project [Waku](https://github.com/waku-org/).

The database configuration:
* host: `recruitment.free.technology`
* port: `5432`
* user: will be provided
* password: will be provided
* database name: `recruitment_task`
* schemas: `raw_github`,`raw_finance`

This repository contains a preconfigured partial stack to let you focus on the data manipulation. However, you are free to use any free technology you like, on the condition we can easily reproduce the result.


## Expectations

We estimate the task you must spend on the task to be approximately 5 hours, we don't expect a full solution.
Sending a partial solution with explanation on additional indicators, data transformation or technical part that could be added to the solution to have a complete solution is fine.

With this task, our goals are to:
* Understand your approach to a real problem.
* Evaluate some keys skills (Data transformation, graphs creation).

It is recommended to submit the tasks result as a git repository containing all the files to reproduce the result.

> If you are using this repository, we recommend that you export the grafana dashboard and add it with the DBT models to the git history.


## Requirements

* Have docker installed

## Usage

* Deploy the container with `make run`
* Shutdown the containers with `make down`
* Build the dbt models with `make dbt-buidlt`
* Compile the dbt models with `make dbt-compile`

The data from the database and grafana are persisted with docker volumes.
