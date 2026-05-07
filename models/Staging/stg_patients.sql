
with dataset as (
    select * from {{ ref('healthcare_patients') }}
)

select
    patient_id,
    gender,
    birth_date,
    insurance_provider
from dataset