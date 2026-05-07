
with dataset as (
    select * from {{ ref('healthcare_clinical_events') }}
)

select
    appointment_id,
    event_name,
    event_timestamp as occurred_at
from dataset