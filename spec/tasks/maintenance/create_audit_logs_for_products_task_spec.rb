# frozen_string_literal: true

require "rails_helper"

module Maintenance
  RSpec.describe CreateAuditLogsForProductsTask do
    let(:process) { described_class.process(product1) }
    let(:collection) { described_class.collection }

    let!(:record_created_at) { DateTime.parse("2023-10-01 06:31:00") }
    let!(:product1) do
      Auditable.without_auditing do
        create(:product,
          name: "Test Product",
          price: 100,
          productable: build(:purchased_product),
          created_at: record_created_at,
        )
      end
    end

    let(:product2) do
      Auditable.without_auditing do
        create(:product,
          name: "Another Product",
          price: 200,
          productable: build(:purchased_product),
          created_at: record_created_at,
        )
      end
    end

    describe "#collection" do
      it "collects products without audit logs" do
        product2.assign_attributes(
          name: "Updated Product",
        )
        Auditable.with_auditing do
          product2.save!
        end
        product3 = Auditable.with_auditing do
          create(:product,
            name: "Last Product",
            price: 400,
            productable: build(:purchased_product),
            created_at: record_created_at,
          )
        end
        expect(collection).not_to include(product3)
        expect(collection).to contain_exactly(product1, product2)
      end
    end

    describe "#process" do
      it "creates an audit log for the product1" do
        allow(Time).to receive(:current).and_return(record_created_at)

        expect { process }.to change(AuditLog, :count).by(1)
        expect(AuditLog.last).to have_attributes(
          action: "create",
          auditable: product1,
          audited_changes: { "_created" => [ nil, product1.name ] },
          audited_fields: [ "_created" ],
          created_at: record_created_at,
          transaction_id: "created by maintenance task: Maintenance::CreateAuditLogsForProductsTask",
          user_id: nil,
        )
      end

      it "sets created_at to the product's created_at" do
        allow(Time).to receive(:current).and_return(record_created_at)

        process
        expect(AuditLog.last.created_at).to eq(record_created_at)
      end

      it "does not create duplicate audit logs" do
        CreateAuditLogsForProductsTask.process(product1)
        CreateAuditLogsForProductsTask.process(product1)
        expect(product1.audit_logs.size).to eq(1)
      end
    end
  end
end
