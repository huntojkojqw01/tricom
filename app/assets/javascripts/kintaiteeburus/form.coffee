jQuery ->
  $("#kintaiteeburu_勤務タイプ").change ()->
    kinmu_type = $(this).val()
    $("#kintaiteeburu_出勤時刻_4i").val(KINMU[kinmu_type].st.split(':')[0])
    $("#kintaiteeburu_出勤時刻_5i").val(KINMU[kinmu_type].st.split(':')[1])

    $("#kintaiteeburu_退社時刻_4i").val(KINMU[kinmu_type].et.split(':')[0])
    $("#kintaiteeburu_退社時刻_5i").val(KINMU[kinmu_type].et.split(':')[1])
