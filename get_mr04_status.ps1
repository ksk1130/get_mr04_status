# �e��p�����[�^
param(
[string]$url   = "http://���[�^��IP�A�h���X/index.cgi/sp/index_contents",
[string]$user  = "���[�UID",
[string]$pass  = "�p�X���[�h"
)

# �ϐ��錾������
set-psdebug -strict

# �G���[�����������_�ŏ����I��
$ErrorActionPreference = "stop"

# �o�b�e���c�ʎ擾
# ����1 �FResponse�I�u�W�F�N�g
# �߂�l�F�o�b�e���c�ʕ�����
function script:GetBatteryStatus($response){
    # �o�b�e���c�ʂ̊i�[���ꂽLI�v�f���擾
    $li_status = $response.ParsedHtml.getElementById("rightStatusArea")

    # LI�v�f�̒�����擪��LI�v�f���擾
    $li_1st = $li_status.getElementsByTagName("li")| select -First 1

    # XXX%�݂̂�؂�o��
    if ( $li_1st.innerHTML -match "\d+%") {
        return $matches[0]
    }
    
    # �擾�ł��Ȃ����"--"��ԋp
    return "--"
}

# �ʐM�ʎ擾
# ����1 �FResponse�I�u�W�F�N�g
# �߂�l�F�ʐM�ʕ�����
function script:GetCommunicationStatus($response){
    # �ʐM�ʂ̊i�[���ꂽDIV�v�f���擾
    $div_article = $response.ParsedHtml.getElementById("article01")

    # DIV�v�f�̒�����擪��TD�v�f���擾
    $td_1st = $div_article.getElementsByTagName("td")| select -First 1

    return $td_1st.innerHTML
}

function script:Main($url,$user,$pass){
    # ���[�UID,�p�X���[�h����BASIC�F�؏����쐬
    $secure_passwd = ConvertTo-SecureString $pass -AsPlainText -Force
    $credential    = New-Object PSCredential $user, $secure_passwd

    # HTML���擾(�p�[�X�ς�)
    $response = Invoke-WebRequest $url -Credential $credential
    
    $battery_status = GetBatteryStatus $response
    $communication_status = GetCommunicationStatus $response
    
    $message = "�o�b�e���c�ʁF$battery_status`r`n�ʐM�ʁ@�@�F$communication_status"

    # �_�C�A���O�\��
    Add-Type -AssemblyName System.Windows.Forms;
    [System.Windows.Forms.MessageBox]::Show($message, "MR04LN STATUS","OK","Information")
}

Main $url $user $pass
