#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PG_ENV="$1"
source "$SCRIPT_PATH/../pg_util.bash"

declare -a roles=("role_admin" "role_manager" "role_Underwriter" "role_accounting"
  "role_dataentry" "role_email_mgmt" "role_uw_calc" "role_UnderwriterLimited"
  "role_collection" "role_FUT_INC_MAKER" "role_FUT_INC_CHECKER"
  "role_FUT_INC_PREPARER" "role_accounting_extern" "role_iso_relations"
  "role_Lender" "role_collateral_provider" "role_mcawfdashboard" "role_extern_cpa")
for role in "${roles[@]}"
do
   pg_execute "INSERT INTO userrole (name, property_name) SELECT * FROM (SELECT '$role' AS name, '$role' AS property_name) AS tmp WHERE NOT EXISTS (SELECT property_name FROM userrole WHERE property_name = '$role');"
done

declare -a permissions=("mca_add_owner" "mca_add_iso" "accounting_w"
  "offer_underwriting_w" "offer_contract_request" "mca_transactions_w"
  "mca_transactions_user" "mca_payment_status_r" "mca_collateral_portfolio_w"
  "mca_send_decline_email" "underwriting_funding_review_approve"
  "underwriting_funding_review_decline" "underwriting_funding_review_modify"
  "underwriting_funding_review_note" "menu_transactions"
  "menu_transactions_advanced" "menu_ref_data" "menu_lender" "menu_pm"
  "menu_collateral_provider" "menu_mca_wf_dashboard" "menu_collection"
  "menu_accounting_dashboard" "menu_mca" "menu_external_cpa" "menu_commission_invoice"
  "menu_aggregation" "menu_pm_refinancecandidates" "menu_pm_dealstatuschange"
  "menu_pm_portfolio" "menu_pm_receivableach" "menu_pm_collateralized_provider_view"
  "menu_pm_time_in_status" "menu_pm_summary" "menu_pm_mcatransactionsummary"
  "menu_pm_collateralportfolio" "menu_pm_investortransprojection" "menu_pm_portfolio_overview"
  "menu_funding_review" "menu_pm_accounting")
for permission in "${permissions[@]}"
do
   pg_execute "INSERT INTO permission (permission, description) SELECT * FROM (SELECT '$permission' AS permission, '' AS description) AS tmp WHERE NOT EXISTS (SELECT permission FROM permission WHERE permission = '$permission');"
done

# Syntax is 
# ROLENAME:PERMISSION,PERMISSION,...
declare -a userroles_permissions=(
  "role_admin:mca_add_owner,mca_add_iso,accounting_w,offer_underwriting_w,offer_contract_request,mca_transactions_w,mca_transactions_user,mca_payment_status_r,mca_collateral_portfolio_w,mca_send_decline_email,underwriting_funding_review_approve,underwriting_funding_review_decline,underwriting_funding_review_modify,underwriting_funding_review_note,menu_transactions,menu_transactions_advanced,menu_ref_data,menu_lender,menu_pm,menu_collateral_provider,menu_mca_wf_dashboard,menu_collection,menu_accounting_dashboard,menu_mca,menu_external_cpa,menu_commission_invoice,menu_aggregation,menu_pm_refinancecandidates,menu_pm_dealstatuschange,menu_pm_portfolio,menu_pm_receivableach,menu_pm_collateralized_provider_view,menu_pm_time_in_status"
  "role_manager:mca_add_owner,mca_add_iso,mca_transactions_w,mca_transactions_user,mca_payment_status_r,mca_collateral_portfolio_w,menu_pm,menu_mca,menu_aggregation,menu_pm_summary,menu_pm_mcatransactionsummary,menu_pm_refinancecandidates,menu_pm_portfolio,menu_pm_receivableach,menu_pm_collateralportfolio,menu_pm_collateralized_provider_view,menu_pm_investortransprojection,menu_pm_portfolio_overview,menu_pm_time_in_status"
  "role_Underwriter:mca_add_owner,mca_add_iso,offer_underwriting_w,offer_contract_request,mca_transactions_w,mca_transactions_user,mca_payment_status_r,mca_send_decline_email,menu_pm,menu_mca,menu_funding_review,menu_pm_refinancecandidates,menu_pm_portfolio,menu_pm_receivableach"
  "role_accounting:mca_add_owner,mca_add_iso,accounting_w,mca_transactions_w,mca_transactions_user,mca_payment_status_r,menu_transactions,menu_transactions_advanced,menu_lender,menu_pm,menu_mca,menu_commission_invoice,menu_aggregation,menu_pm_refinancecandidates,menu_pm_accounting,menu_pm_dealstatuschange,menu_pm_portfolio,menu_pm_receivableach,menu_pm_collateralportfolio,menu_pm_investortransprojection,menu_pm_portfolio_overview"
  "role_dataentry:mca_add_owner,mca_add_iso,offer_contract_request,menu_mca"
  "role_email_mgmt:mca_add_owner,mca_add_iso,menu_mca"
  "role_uw_calc:mca_add_owner,mca_add_iso,menu_mca"
  "role_UnderwriterLimited:offer_underwriting_w,menu_funding_review"
  "role_collection:mca_payment_status_r,menu_collection,menu_mca,menu_pm_portfolio"
  "role_FUT_INC_MAKER:underwriting_funding_review_approve,underwriting_funding_review_decline,underwriting_funding_review_modify,underwriting_funding_review_note,menu_funding_review"
  "role_FUT_INC_CHECKER:underwriting_funding_review_decline,underwriting_funding_review_modify,underwriting_funding_review_note,menu_pm_accounting"
  "role_FUT_INC_PREPARER:underwriting_funding_review_note,menu_funding_review"
  "role_accounting_extern:menu_transactions,menu_transactions_advanced"
  "role_iso_relations:menu_transactions,menu_pm,menu_mca,menu_commission_invoice,menu_pm_refinancecandidates"
  "role_Lender:menu_lender"
  "role_collateral_provider:menu_pm,menu_collateral_provider,menu_pm_collateralized_provider_view"
  "role_mcawfdashboard:menu_mca_wf_dashboard"
  "role_extern_cpa:menu_external_cpa"
)
for userrole_permissions in "${userroles_permissions[@]}"
do
  unset permissions_list
  if [[ $userrole_permissions == *":"* ]]
  then
    tmp_array=(${userrole_permissions//:/ })
    userrole_permissions=${tmp_array[0]}
    permissions_list=${tmp_array[1]}
    permissions_list=(${permissions_list//,/ })
  fi

  for permission in ${permissions_list[@]}
  do
    pg_execute "SELECT COUNT(*) FROM userroles_permissions WHERE role_id = (SELECT id FROM userrole WHERE property_name = '$userrole_permissions') AND permission_id = (SELECT id FROM permission WHERE permission = '$permission');" > tmp_output
    not_exists=`cat tmp_output | grep 0`
    if [ "$not_exists" ];
    then
      pg_execute "INSERT INTO userroles_permissions (role_id, permission_id) SELECT * FROM (SELECT id AS role_id FROM userrole WHERE property_name = '$userrole_permissions') AS ur LEFT JOIN (SELECT id AS permission_id FROM permission WHERE permission IN ('$permission')) AS p ON 1 = 1;"
    fi
    rm -f tmp_output
  done
done