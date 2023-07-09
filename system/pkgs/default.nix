self: super:
{
    adi1090x-plymouth = super.callPackage ./custom/adi1090x-plymouth { };
    grafanaDashboardsConfig = super.callPackage ./custom/grafana_dashboards { };
}
