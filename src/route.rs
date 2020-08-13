use yew_router::prelude::*;

#[derive(Switch, Debug, Clone)]
pub enum Route {
    #[to = "/"]
    ProjectsPage,
    #[to = "/aboutme"]
    AboutMePage,
}
