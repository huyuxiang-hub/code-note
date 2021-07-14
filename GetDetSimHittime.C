#include "Event/SimEvent.h"
#include "TFile.h"
#include "TTree.h"
#include <vector>
unsigned int CdID2pmtID(unsigned int id)
{
    unsigned int pmtid = id - (0x10<<24);
    return (pmtid>>8);
}
void GetDetSimHittime()
{
    using namespace std;

//    vector<JM::SimPMTHit* > *v_cd_hits;
    JM::SimEvent* sim_event = new JM::SimEvent();
//    TFile* f = TFile::Open("root://junoeos01.ihep.ac.cn//eos/juno/user/luoxj/Sim_DSNB/gamma_0_0_0/detsim/root/detsim-89.root", "read");
    TFile* f = TFile::Open("det_sample.root", "read");
    TTree* tDet = (TTree*) f->Get("Event/Sim/SimEvent");
//    tDet->SetBranchAddress("m_cd_hits", &v_cd_hits );
    tDet->SetBranchAddress("SimEvent", &sim_event );
    tDet->GetEntry(0);
//    cout << CdID2pmtID(v_cd_hits->at(2)->getPMTID()) <<endl;
    const vector<JM::SimPMTHit*>& v_cd_hits = sim_event->getCDHitsVec();
    for(int i=0; i<v_cd_hits.size();i++)
    {
        cout << "PMTID:\t"<<v_cd_hits[i]->getPMTID() <<endl;
        cout << "Hit-Time:\t"<<v_cd_hits[i]->getHitTime() <<endl;
        cout << "Npe:\t" << v_cd_hits[i]->getNPE() <<endl;
    }
    
}

