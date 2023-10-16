from singleton_decorator import singleton
from objcache import objcache_get_entire_table


@singleton
class AppConstants:

    def __init__(self, cnf):
        self._cnf = cnf
        self.trans_direction = {}
        self.trans_statuses_id = {}
        self.trans_statuses_name = {}
        self.trans_statuses_canceled = None
        self.trans_statuses_returned = None
        self.trans_statuses_allocated = None
        self.trans_statuses_pending = None
        self.trans_statuses_processed = None
        self.trans_statuses_prepared = None
        self.trans_statuses_manual = None
        self.trans_statuses_scheduled = None
        self.trans_statuses_sent = None
        self.trans_statuses_hold = None
        self.trans_statuses_failed = None
        self.trans_statuses_resched = None

        self.trans_types_id = {}
        self.trans_types_name = {}
        self.trans_type_placeholder = -1
        self.trans_type_payment = None
        self.trans_type_deposit = None
        self.trans_type_depositConsolidate = None
        self.trans_type_depositToMerchant = None
        self.trans_type_depositToOutstanding = None
        self.trans_type_commission = None
        self.trans_type_fee = None
        self.trans_type_mgmtfee = None
        self.trans_type_contractfee = None
        self.trans_type_tfi = None
        self.trans_type_withdrawal = None
        self.trans_type_discount = None
        self.trans_type_default = None
        self.trans_type_recall = None
        self.trans_type_refund = None
        self.trans_type_nonachpmnt = None
        self.trans_type_settlement = None

        self.trans_sub_types_id = {}
        self.trans_sub_types_name = {}
        self.trans_sub_type_nsffee = None
        self.trans_sub_type_default = None
        self.trans_sub_type_blocked_p = None
        self.trans_sub_type_stacking_fee = None
        self.trans_sub_type_commission = None
        self.trans_sub_type_cf = None
        self.trans_sub_type_cf_extra_points = None
        self.trans_sub_type_ucc = None
        self.trans_sub_type_rtr_fee = None
        self.trans_sub_type_monthly_admin_fee = None
        self.trans_sub_type_wire_fee = None
        self.trans_sub_type_nonachpmnt = None
        self.trans_sub_type_bonus = None
        self.trans_sub_type_settlement = None
        self.trans_sub_type_mgmt_fee = None
        self.trans_sub_type_acct_change = None
        self.trans_sub_type_interest = None
        self.trans_sub_type_principal = None
        self.trans_sub_type_loan = None
        self.trans_sub_type_expenses = None
        self.trans_sub_type_3rd_party_coll_fee = None

        self.agg_transstat_processed = []
        self.agg_transstat_processedPending = []
        self.agg_transstat_scheduled = []
        self.agg_transstat_sent = []
        self.agg_transstat_notCompleted = []
        self.agg_transstat_lenderBalanceTotal = []
        self.agg_transstat_activ = []
        self.agg_transstat_notActive = []
        self.agg_transstat_canceled = []
        self.agg_transstat_sentAndReady = []
        self.agg_transstat_failed = []
        self.agg_transstat_holdSuspend = []
        self.agg_transstat_activeAndExpected = []
        self.agg_transtype_sendToMerchant = []
        self.agg_transstat_activeAndReturned = []

        self._user_withdrawal_days = None

        self._user_commission_strategies = None
        self.comm_pay_strat_byincrement = 1
        self.comm_pay_strat_all = 2
        self.comm_pay_strat_50_50 = 3

        self.account_types = {}
        self.account_type_checking = None
        self.account_type_saving = None

        self.amountbaseindicator = {}
        self.amountbaseindicator_FA = -1
        self.amountbaseindicator_RTR = -1
        self.amountbaseindicator_TP = -1

        self.rate_type_contract = 1
        self.rate_type_discount = 2
        self.rate_type_rescind = 3
        self.rate_type_settlement = 4
        self.rate_type_description = {
            self.rate_type_contract: 'Contract',
            self.rate_type_discount: 'Discount',
            self.rate_type_rescind: 'Rescind',
            self.rate_type_settlement: 'Settlement'
        }

        self.external_document_docusign = 1
        self.mcadoc_id2category = {}

        self._db_init(cnf)

    def _db_init(self, cnf):
        for i in objcache_get_entire_table(self._cnf, 'transstatus', False):
            self.trans_statuses_id[i[0]] = i[1]
            self.trans_statuses_name[i[1]] = i[0]

        for i in objcache_get_entire_table(self._cnf, 'transtype', False):
            self.trans_types_id[i[0]] = i[1]
            self.trans_types_name[i[1]] = i[0]
            self.trans_direction[i[0]] = i[2]

        for i in objcache_get_entire_table(self._cnf, 'transsubtype', False):
            self.trans_sub_types_id[i[0]] = {'name': i[1], 'def': i[2] or 0.0}
            self.trans_sub_types_name[i[1]] = i[0]
        self.trans_sub_types_id[0] = {'name': '', 'def': 0.0}
        self.trans_sub_types_name[''] = 0
        self.trans_sub_type_nsffee = self.trans_sub_types_name['NSF Fee']
        self.trans_sub_type_default = self.trans_sub_types_name['Default Fee']
        self.trans_sub_type_blocked_p = self.trans_sub_types_name['Block Payment']
        self.trans_sub_type_stacking_fee = self.trans_sub_types_name['Stacking Fee']
        self.trans_sub_type_ucc = self.trans_sub_types_name['UCC Term']
        self.trans_sub_type_commission = self.trans_sub_types_name['Commission']
        self.trans_sub_type_cf = self.trans_sub_types_name['Contract Fee']
        self.trans_sub_type_rtr_fee = self.trans_sub_types_name['RTR Fee']
        self.trans_sub_type_monthly_admin_fee = self.trans_sub_types_name['Month Admin Fee']
        self.trans_sub_type_wire_fee = self.trans_sub_types_name['Wire Fee']
        self.trans_sub_type_nonachpmnt = self.trans_sub_types_name['Non ACH Fee']
        self.trans_sub_type_bonus = self.trans_sub_types_name['Bonus']
        self.trans_sub_type_settlement = self.trans_sub_types_name['Settlement']
        self.trans_sub_type_cf_extra_points = self.trans_sub_types_name['CF Extra Points']
        self.trans_sub_type_mgmt_fee = self.trans_sub_types_name['Management fee']
        self.trans_sub_type_acct_change = self.trans_sub_types_name['Acct Change']
        self.trans_sub_type_interest = self.trans_sub_types_name['Interest']
        self.trans_sub_type_principal = self.trans_sub_types_name['Principal']
        self.trans_sub_type_loan = self.trans_sub_types_name['Loan']
        self.trans_sub_type_invoice = self.trans_sub_types_name['Invoice']
        self.trans_sub_type_expenses = self.trans_sub_types_name['Expenses']
        self.trans_sub_type_3rd_party_coll_fee = self.trans_sub_types_name['3rd Party Collection Fee']

        self._init_add_transtypes()
        self._inint_user_strat_tables()
        self._init_account_types()
        self._init_mcadoc_types()

    def _init_add_transtypes(self):
        agg_cnf = self._cnf['tranStatAggreg']
        self.trans_statuses_canceled = self.trans_statuses_name['Canceled']
        self.trans_statuses_returned = self.trans_statuses_name['Returned']
        self.trans_statuses_allocated = self.trans_statuses_name['Allocated']
        self.trans_statuses_pending = self.trans_statuses_name['Pending']
        self.trans_statuses_processed = self.trans_statuses_name['Processed']
        self.trans_statuses_prepared = self.trans_statuses_name['Prepared']
        self.trans_statuses_manual = self.trans_statuses_name['Manual']
        self.trans_statuses_scheduled = self.trans_statuses_name['Scheduled']
        self.trans_statuses_sent = self.trans_statuses_name['Sent']
        self.trans_statuses_hold = self.trans_statuses_name['Hold']
        self.trans_statuses_failed = self.trans_statuses_name['Failed']
        self.trans_statuses_resched = self.trans_statuses_name['ReScheduled']

        self.agg_transstat_processed = [self.trans_statuses_name[i] for i in agg_cnf['processed']]
        self.agg_transstat_scheduled = [self.trans_statuses_name[i] for i in agg_cnf['scheduled']]
        self.agg_transstat_sent = [self.trans_statuses_name[i] for i in agg_cnf['sent']]
        self.agg_transstat_notCompleted = [self.trans_statuses_name[i] for i in agg_cnf['notCompleted']]
        self.agg_transstat_lenderBalanceTotal = [self.trans_statuses_name[i] for i in agg_cnf['lenderBalanceTotal']]
        self.agg_transstat_activ = [self.trans_statuses_name[i] for i in agg_cnf['activ']]
        self.agg_transstat_notActive = [self.trans_statuses_name[i] for i in agg_cnf['notActive']]
        self.agg_transstat_canceled = [self.trans_statuses_name[i] for i in agg_cnf['canceled']]
        self.agg_transstat_sentAndReady = [self.trans_statuses_name[i] for i in agg_cnf['sentAndReady']]
        self.agg_transstat_failed = [self.trans_statuses_name[i] for i in agg_cnf['failed']]
        self.agg_transstat_holdSuspend = [self.trans_statuses_name[i] for i in agg_cnf['holdSuspend']]
        self.agg_transstat_activeAndExpected = [self.trans_statuses_name[i] for i in agg_cnf['activeAndExpected']]
        self.agg_transstat_processedPending = [self.trans_statuses_processed, self.trans_statuses_pending]
        self.agg_transstat_activeAndReturned = [self.trans_statuses_name[i] for i in agg_cnf['activeAndReturned']]

        self.agg_transtype_sendToMerchant = [self.trans_types_name[i] for i in
                                             self._cnf['tranTypeAggreg']['sendToMerchant']]
        self.agg_transtype_merchantPayments = [self.trans_types_name[i] for i in
                                               self._cnf['tranTypeAggreg']['merchantPayments']]
        self.agg_transtype_merchantPaymentsWithoutDefault = [self.trans_types_name[i] for i in
                                               self._cnf['tranTypeAggreg']['merchantPaymentsWithoutDefault']]

        self.trans_type_payment = self.trans_types_name['Payment']
        self.trans_type_deposit = self.trans_types_name['Deposit']
        self.trans_type_depositConsolidate = self.trans_types_name['Deposit Consolidate']
        self.trans_type_depositToMerchant = self.trans_types_name['Deposit To Merchant']
        self.trans_type_depositToOutstanding = self.trans_types_name['Deposit To Outstanding']
        self.trans_type_commission = self.trans_types_name['Commission']
        self.trans_type_fee = self.trans_types_name['Fee']
        self.trans_type_mgmtfee = self.trans_types_name['Mgmt Fee']
        self.trans_type_contractfee = self.trans_types_name['Contract Fee']
        self.trans_type_tfi = self.trans_types_name['TFI']
        self.trans_type_withdrawal = self.trans_types_name['Withdrawal']
        self.trans_type_discount = self.trans_types_name['Discount']
        self.trans_type_default = self.trans_types_name['Default']
        self.trans_type_recall = self.trans_types_name['Recall']
        self.trans_type_placeholder = self.trans_types_name['Placeholder']
        self.trans_type_refund = self.trans_types_name['Refund']
        self.trans_type_nonachpmnt = self.trans_types_name['Non ACH Pmnt']
        self.trans_type_settlement = self.trans_types_name['Settlement']

    def _inint_user_strat_tables(self):
        self._user_withdrawal_days = {}
        for i in objcache_get_entire_table(self._cnf, 'userpaydaytype', False):
            self._user_withdrawal_days[i[0]] = i[1]

        self._user_commission_strategies = {}
        for i in objcache_get_entire_table(self._cnf, 'usercomissionstrategy', False):
            self._user_commission_strategies[i[0]] = i[1]

    def get_withdrawal_days(self):
        return self._user_withdrawal_days

    def get_commission_strategies(self):
        return self._user_commission_strategies

    def _init_account_types(self):
        self.account_types = {}
        for i in objcache_get_entire_table(self._cnf, 'accounttype', False):
            self.account_types[i[0]] = i[1]
            if i[1] == 'CHECKING':
                self.account_type_checking = i[0]
            elif i[1] == 'SAVING':
                self.account_type_saving = i[0]

        self.amountbaseindicator = {}
        for i in objcache_get_entire_table(self._cnf, 'amountbaseindicator', False):
            self.amountbaseindicator[i[0]] = i[1]
            if i[1] == 'FA':
                self.amountbaseindicator_FA = i[0]
            elif i[1] == 'RTR':
                self.amountbaseindicator_RTR = i[0]
            elif i[1] == 'TP':
                self.amountbaseindicator_TP = i[0]

    def _init_mcadoc_types(self):
        mapping = {
            'contract': 'Merchant Contract',
            'balanceletter': 'Balance Letter / Contract',
            'driver_license': 'Voided Check / Driver License',
            'experian_report': 'Background Report: Experian (Business / Personal)',
            'consolidation_grid': 'Consolidation Grid',
            'final_funding_docs': 'Final Funding Docs',
            'final_funding_docs_signed': 'Final Funding Doc (Signed Contract)',
            'syndication_contract': 'Syndication Contract',
            'internal_payment_history': 'Internal Payment History',
            'schedule_daily_weekly_incremental': 'Schedule (Daily, Weekly or Incremental)',
            'dept_of_state_report': 'Background Report: Dept of State (Business)',
            'lawyer_legal_documents': 'Lawyer/Legal Documents',
            'debt_sheet': 'Debt Sheet',
            'dba_details': 'DBA Details',
            'bank_statement_weekly_daily': 'Bank Statement (Weekly/Daily)',
            'tlo_report': 'TLO Report',
            'taxguard_8821': 'TaxGuard 8821',
            'copy_of_coj': 'Copy of COJ',
            'proof_of_ownership': 'Proof of Ownership',
            'settlement_agreement': 'Settlement Agreement',
            'miami_dade_court': 'Background Report: Miami Dade Court',
            'data_merch': 'Data Merch',
            'ein_number': 'EIN Number',
            'tax_returns': 'Tax Returns',
            'miami_date_nys_courts': 'Background Report: Miami Date & NYS Courts',
            'merchant_application': 'Merchant Application',
            'compressed_documents': 'Compressed Documents',
            'bank_statement_monthly': 'Bank Statement (Monthly)',
            'credit_card_statements_monthly': 'Credit Card Statements (Monthly)',
            'bank_financial_stmt_analysis': 'Bank Financial Stmt Analysis',
            'clear_business_personal': 'Background Report: CLEAR (Business / Personal)',
            'pictures_of_facilities': 'Pictures of Facilities',
            'ucc': 'UCC',
            'funding_call_merchant_interview': 'Funding Call / Merchant Interview',
            'ar_report': 'AR Report (Inc Checks & Invoices)',
            'ar_cover_letter': 'AR Cover Letter',
            'banana_report': 'Banana Report',
            'incremental_grid': 'Incremental Grid'
        }

        consts = {}
        table = self._cnf['pg']['refmodules']['doccategory']
        for c in objcache_get_entire_table(self._cnf, table):
            consts[c['category']] = c['id']

        for k, v in mapping.items():
            if consts.get(v):
                setattr(self, 'mcadoc_' + k, consts[v])
                self.mcadoc_id2category[consts.get(v)] = k

    @staticmethod
    def load_constants(cnf, table, obj):
        for rec in objcache_get_entire_table(cnf, table, True):
            setattr(obj, rec['property_name'], rec['id'])

        return True
