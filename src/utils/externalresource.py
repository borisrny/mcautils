from singleton_decorator import singleton


@singleton
class ExternalDocConstants:

    def __init__(self, cnf):
        self._cnf = cnf

        self.docusign_envelope_status_id = {}
        self.docusign_envelope_status_name = {}

        self.docusign_envelope_status_authoritativecopy = None
        self.docusign_envelope_status_completed = None
        self.docusign_envelope_status_correct = None
        self.docusign_envelope_status_created = None
        self.docusign_envelope_status_declined = None
        self.docusign_envelope_status_deleted = None
        self.docusign_envelope_status_delivered = None
        self.docusign_envelope_status_sent = None
        self.docusign_envelope_status_signed = None
        self.docusign_envelope_status_template = None
        self.docusign_envelope_status_timedout = None
        self.docusign_envelope_status_transfercompleted = None
        self.docusign_envelope_status_voided = None

        self.docusign_recipient_status_id = {}
        self.docusign_recipient_status_name = {}

        self.docusign_recipient_status_autoresponded = None
        self.docusign_recipient_status_completed = None
        self.docusign_recipient_status_created = None
        self.docusign_recipient_status_declined = None
        self.docusign_recipient_status_delivered = None
        self.docusign_recipient_status_faxpending = None
        self.docusign_recipient_status_sent = None
        self.docusign_recipient_status_signed = None

        self._inint_docusign_envelope()
        self._inint_docusign_recipient()


    def _inint_docusign_envelope(self):
        self.docusign_envelope_status_id = {
            0: '',                      # Empty status
            1: 'authoritativecopy',     # The envelope is in an authoritative state. Only copy views of the documents will be shown.
            2: 'completed',             # The envelope has been completed by all the recipients.
            3: 'correct',               # The envelope has been opened by the sender for correction. The signing process is stopped for envelopes with this envelope.
            4: 'created',               # The envelope is in a draft state and has not been sent for signing.
            5: 'declined',              # The envelope has been declined for signing by one of the recipients.
            6: 'deleted',               # This is a legacy envelope and is no longer used.
            7: 'delivered',             # All recipients have viewed the document(s) in an envelope through the DocuSign signing website. This does not indicate an email delivery of the documents in an envelope.
            8: 'sent',                  # An email notification with a link to the envelope has been sent to at least one recipient. The envelope remains in this state until all recipients have viewed it at a minimum.
            9: 'signed',                # The envelope has been signed by all the recipients. This is a temporary state during processing, after which the envelope is automatically moved to completed envelope.
            10: 'template',             # The envelope is a template.
            11: 'timedout',             # This is a legacy envelope and is no longer used.
            12: 'transfercompleted',    # The envelope has been transferred out of DocuSign to another authority.
            13: 'voided'                # The envelope has been voided by the sender or has expired. The void reason indicates whether the envelope was manually voided or expired.
        }

        self.docusign_envelope_status_name = {v: k for k, v in self.docusign_envelope_status_id.items()}

        self.docusign_envelope_status_authoritativecopy = self.docusign_envelope_status_name['authoritativecopy']
        self.docusign_envelope_status_completed = self.docusign_envelope_status_name['completed']
        self.docusign_envelope_status_correct = self.docusign_envelope_status_name['correct']
        self.docusign_envelope_status_created = self.docusign_envelope_status_name['created']
        self.docusign_envelope_status_declined = self.docusign_envelope_status_name['declined']
        self.docusign_envelope_status_deleted = self.docusign_envelope_status_name['deleted']
        self.docusign_envelope_status_delivered = self.docusign_envelope_status_name['delivered']
        self.docusign_envelope_status_sent = self.docusign_envelope_status_name['sent']
        self.docusign_envelope_status_signed = self.docusign_envelope_status_name['signed']
        self.docusign_envelope_status_template = self.docusign_envelope_status_name['template']
        self.docusign_envelope_status_timedout = self.docusign_envelope_status_name['timedout']
        self.docusign_envelope_status_transfercompleted = self.docusign_envelope_status_name['transfercompleted']
        self.docusign_envelope_status_voided = self.docusign_envelope_status_name['voided']

    def _inint_docusign_recipient(self):
        self.docusign_recipient_status_id = {
            0: '',              # Empty status
            1: 'autoresponded', # The recipient’s email system auto-responded to the email from DocuSign. This status is used in the DocuSign web app (also known as the DocuSign console) to inform senders about the auto-responded email.
            2: 'completed',     # The recipient has completed their actions (signing or other required actions if not a signer) for an envelope.
            3: 'created',       # The recipient's envelope is in a draft state (the envelope status is created).
            4: 'declined',      # The recipient declined to sign the document(s) in the envelope.
            5: 'delivered',     # The recipient has viewed the document(s) in an envelope through the DocuSign signing website. This does not indicate an email delivery of the documents in an envelope.
            6: 'faxpending',    # The recipient has finished signing, and the system is awaiting a fax attachment by the recipient before completing their signing step.
            7: 'sent',          # The recipient has been sent an email notification that it is their turn to sign an envelope.
            8: 'signed',        # The recipient has completed (performed all required interactions, such as signing or entering data) all required tags in an envelope. This is a temporary state during processing, after which the recipient status is automatically updated to completed.
        }

        self.docusign_recipient_status_name = {v: k for k, v in self.docusign_recipient_status_id.items()}

        self.docusign_recipient_status_autoresponded = self.docusign_recipient_status_name['autoresponded']
        self.docusign_recipient_status_completed = self.docusign_recipient_status_name['completed']
        self.docusign_recipient_status_created = self.docusign_recipient_status_name['created']
        self.docusign_recipient_status_declined = self.docusign_recipient_status_name['declined']
        self.docusign_recipient_status_delivered = self.docusign_recipient_status_name['delivered']
        self.docusign_recipient_status_faxpending = self.docusign_recipient_status_name['faxpending']
        self.docusign_recipient_status_sent = self.docusign_recipient_status_name['sent']
        self.docusign_recipient_status_signed = self.docusign_recipient_status_name['signed']
