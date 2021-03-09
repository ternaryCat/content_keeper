RSpec.describe Users::Create, type: :feature do
  subject { described_class }

  let(:provider) { 'telegram' }
  let(:uid) { '123456703' }
  let(:first_name) { 'Andrew' }
  let(:last_name) { 'Karelskiy' }
  let(:username) { 'TgUsername' }
  let(:language_code) { 'en' }

  describe '.call' do
    context 'when valid' do
      it 'creates with all params' do
        user = subject.call provider: provider,
                            uid: uid,
                            first_name: first_name,
                            last_name: last_name,
                            username: username,
                            language_code: language_code
        expect(user.present? && user.persisted?).to be_truthy
      end

      it 'creates with minimal params' do
        user = subject.call provider: provider, uid: uid
        expect(user.present? && user.persisted?).to be_truthy
      end

      it 'creates authentication with user' do
        user = subject.call provider: provider, uid: uid
        expect(user.authentications.first.present?).to be_truthy
      end

      it 'creates authentication with provider' do
        user = subject.call provider: provider, uid: uid
        expect(user.authentications.first.provider).to eq provider
      end

      it 'creates authentication with first_name' do
        user = subject.call provider: provider, uid: uid, first_name: first_name
        expect(user.authentications.first.first_name).to eq first_name
      end

      it 'creates authentication with last_name' do
        user = subject.call provider: provider, uid: uid, last_name: last_name
        expect(user.authentications.first.last_name).to eq last_name
      end

      it 'creates authentication with username' do
        user = subject.call provider: provider, uid: uid, username: username
        expect(user.authentications.first.username).to eq username
      end

      it 'creates authentication with language_code' do
        user = subject.call provider: provider, uid: uid, language_code: language_code
        expect(user.authentications.first.language_code).to eq language_code
      end
    end

    context 'when invalid' do
      it 'raises KeyError by missing required params' do
        expect { subject.call }.to raise_error KeyError
      end

      it 'raises KeyError by missing uid' do
        expect { subject.call provider: provider }.to raise_error KeyError
      end

      it 'raises AlreadyExistsError by exists authentication' do
        Authentication.create! provider: provider, uid: uid, user: User.create
        expect { subject.call provider: provider, uid: uid }.to raise_error Users::Create::AlreadyExistsError
      end
    end
  end
end
