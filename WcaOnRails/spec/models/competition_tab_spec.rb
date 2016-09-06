# frozen_string_literal: true
require 'rails_helper'

RSpec.describe CompetitionTab, type: :model do
  it "has a valid factory" do
    expect(FactoryGirl.build(:competition_tab)).to be_valid
  end

  it "ensures all attributes are defined as either cloneable or uncloneable" do
    expect(CompetitionTab.column_names).to match_array(CompetitionTab::CLONEABLE_ATTRIBUTES + CompetitionTab::UNCLONEABLE_ATTRIBUTES)
  end

  context "#display_order" do
    let(:competition) { FactoryGirl.create(:competition) }
    let(:other_competition) { FactoryGirl.create(:competition) }

    it "increases by one for new created tabs" do
      FactoryGirl.create_list(:competition_tab, 3, competition: competition)
      expect(competition.tabs.pluck(:display_order)).to eq [1, 2, 3]
    end

    it "starts from 1 for each competition" do
      2.times do
        FactoryGirl.create(:competition_tab, competition: competition)
        FactoryGirl.create(:competition_tab, competition: other_competition)
      end
      expect(competition.tabs.pluck(:display_order)).to eq [1, 2]
      expect(other_competition.tabs.pluck(:display_order)).to eq [1, 2]
    end

    it "are updated correctly after a tab is deleted" do
      FactoryGirl.create_list(:competition_tab, 5, competition: competition)
      competition.tabs.second.destroy
      expect(competition.tabs.pluck(:display_order)).to eq [1, 2, 3, 4]
      competition.tabs.first.destroy
      expect(competition.tabs.pluck(:display_order)).to eq [1, 2, 3]
      competition.tabs.last.destroy
      expect(competition.tabs.pluck(:display_order)).to eq [1, 2]
    end
  end

  context "#reorder" do
    let!(:competition) { FactoryGirl.create(:competition) }
    let!(:tab1) { FactoryGirl.create(:competition_tab, competition: competition) }
    let!(:tab2) { FactoryGirl.create(:competition_tab, competition: competition) }
    let!(:tab3) { FactoryGirl.create(:competition_tab, competition: competition) }

    it "can swap tab with its predecessor" do
      tab2.reorder("up")
      expect(competition.tabs.to_a).to eq [tab2, tab1, tab3]
    end

    it "can swap tab with its successor" do
      tab2.reorder("down")
      expect(competition.tabs.to_a).to eq [tab1, tab3, tab2]
    end

    it "doesn't change anything when swapping first tab with its predecessor" do
      tab1.reorder("up")
      expect(competition.tabs.to_a).to eq [tab1, tab2, tab3]
    end

    it "doesn't change anything when swapping last tab with its successor" do
      tab3.reorder("down")
      expect(competition.tabs.to_a).to eq [tab1, tab2, tab3]
    end
  end
end
